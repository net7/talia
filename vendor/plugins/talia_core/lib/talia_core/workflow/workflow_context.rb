require 'local_store/workflow_record'
require 'workflow/workflow_action'


module TaliaCore
  
  class WorkflowContext
  
    # initialize Workflow Context class
    def initialize
    
    end
  
    # set source id
    # * value: source id
    def source=(value)
      @source_record_id = value
    end
  
    # add new method to Workflow Context class.
    # This method is called when state_machine enter in new state
    # * name: state name. Became new method name
    def add_action(name)
    
      # require workflow action class if it is present
      if action_class_is_present?(name)
        require action_class_filename(name)
      else
        raise "Workflow action class for #{name} is not present."
      end
    
      # get action class object
      actionClassObject = Object.const_get("TaliaCore").const_get(action_class_name(name))
    
      # define new method called name
      self.class.send(:define_method, name.to_sym) { |*args|
      
        # run "execute" method of WorkflowAction class
        actionClassObject.new.execute(args)
      
        # save current state
        wr = WorkflowRecord.find(:first, :conditions => {:source_record_id => @source_record_id})
        wr.state = name
        wr.save
      }
    end
  
    # check if workflow action class is present
    # * name: class name
    def action_class_is_present?(name)
      File.exist?(action_class_filename(name) + '.rb')
    end

    # tanslate action name into action class filename
    # * name: class name
    def action_class_filename(name)
      File.join(File.dirname(__FILE__), "action", (name + "_action").downcase)
    end
  
    # tanslate action name into action class name
    # * name: class name
    def action_class_name(name)
      name.capitalize + "Action"
    end

  end

end