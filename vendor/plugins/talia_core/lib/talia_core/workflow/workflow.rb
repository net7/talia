require 'workflow/workflow_context'
require 'workflow/workflow_record'

# Workflow class
class Workflow
  
  # initialize current workflow
  # * transitions: transitions as Array of 3 string element (origin state, event, destination state)
  def initialize(transitions)
    # build statemachine
    @workflow_machine = Statemachine.build do
      # add all transitions
      transitions.collect { |origin_state, event, destination_state|
        trans origin_state, event, destination_state, destination_state
      }
      
      # set context class for action execution
      context WorkflowContext.new
    end
        
    # create new Workflow Context object
    @workflow_context = @workflow_machine.context
    
    # create transitions for all action
    transitions.each { |item|
      @workflow_context.add_action(item[2].to_s)
    }
    
    @workflow_machine
  end
  
  # get source id for current workflow
  def get_source
    return @source_id
  end
  
  # get current state 
  def get_state
    return @workflow_machine.state
  end

  
  # call action of state machine
  # * event: event
  # * user: user that call event
  # * options: options for event. Default value is nil
  def action(event, user, options = nil)
    raise "Event can be execute before set source id" if get_source.nil?
    
    @workflow_machine.send(event, options)
  end
  
  # set source id for current workflow
  # Setting sorce id, the state will be reload from database
  def set_source(source_id)
    # set source id
    @source_id = source_id
    @workflow_context.set_source(source_id)
    
    # load data
    get_data
  end
  
  
  private
  
  # set state
  def set_state(value)
    @workflow_machine.state = value.to_sym
  end
    
  # get data if record exist or create new record.
  def get_data
    # check data record
    wr_count = WorkflowRecord.count(:conditions => {:source_id => get_source})
    if wr_count  > 0
      load_data
    else
      create_data
    end
  end
  
  # load data from record
  def load_data
    # load current state
    wr = WorkflowRecord.find(:first, :conditions => {:source_id => get_source})
    set_state(wr.state)
  end
  
  # create new record
  def create_data
    # create new record
    wr = WorkflowRecord.new
    wr.source_id = get_source
    wr.state = get_state.to_s
    wr.save
  end
  
end