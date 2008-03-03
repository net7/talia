require 'ostruct'
require 'workflow/workflow'
require 'rexml/document'

# Workflow Builder class
#
# Example:
# 
# workflow1 = WorkflowBuilder.workflow 1 do
#   WorkflowBuilder.step "submitted","review","reviewed"
#   WorkflowBuilder.step "reviewed","publish","published"
#   WorkflowBuilder.step "published", "auto","published"
# end
class WorkflowBuilder < OpenStruct
  
  @transitions = []
  
  # Create new workflow
  # * source_id: source id
  def self.workflow
    yield if block_given?
    return Workflow.new(@transitions)
  end
  
  # load workflow from xml file
  def self.load_xml(source_id,name,filename)
    # load xml file
    file = File.new(filename)
    xml_data = REXML::Document.new file
    
    # get workflow configuration by name
    workflow_configuration = xml_data.elements["//root/workflow[@name='#{name}']"]
    
    # read all workflow step
    workflow_configuration.elements.each { |element| 
      @transitions << [element.attribute("start").to_s.to_sym, 
                       element.attribute("event").to_s.to_sym, 
                       element.attribute("end").to_s.to_sym]
    }
    
    # create new workflow and set source id
    workflow = self.workflow
    workflow.set_source(source_id)
    
    # return workflow
    return workflow
  end
  
  # load workflow from dsl file
  def self.load_dsl(source_id,filename)
    # build workflow
    dsl = new
    workflow = dsl.instance_eval(File.read(filename), filename)
    
    # set source id
    workflow.set_source(source_id)
    
    # return workflow
    return workflow
  end
  
  # Add step to workflow
  # * origin_state: origin state of transition
  # * event: event that execute the transition
  # * destination_state: destination state of transition
  def self.step(origin_state, event, destination_state)
    @transitions << [origin_state.to_sym, event.to_sym, destination_state.to_sym]
  end

  private
  
  #def Workflow.queues 
  #  Hash.new
  #end
  
end
