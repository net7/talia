require 'ostruct'
require 'rexml/document'
require 'workflow/workflow'

module TaliaCore
  
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
    # * source_record_id: source id
    def self.workflow
      yield if block_given?
      return Workflow.new(@transitions)
    end
  
    # load workflow from xml file
    # * source_record_id: source id
    # * filename: file to load
    # * name: load workflow by name (optional)
    def self.load_xml(source_record_id, filename, name = nil)
      # load xml file
      file = File.new(filename)
      xml_data = REXML::Document.new file
    
      # get workflow configuration by name
      if (name.nil?)
        workflow_configuration = xml_data.elements["//root/workflow"]
      else
        workflow_configuration = xml_data.elements["//root/workflow[@name='#{name}']"]
      end
    
      # read all workflow step
      workflow_configuration.elements.each { |element| 
        @transitions << [element.attribute("start").to_s.to_sym, 
          element.attribute("event").to_s.to_sym, 
          element.attribute("end").to_s.to_sym]
      }
    
      # create new workflow and set source id
      workflow = self.workflow
      workflow.source = source_record_id
    
      # return workflow
      return workflow
    end
  
    # load workflow from dsl file
    # * source_record_id: source id
    # * filename: file to load
    def self.load_dsl(source_record_id,filename)
      # build workflow
      dsl = new
      workflow = dsl.instance_eval(File.read(filename), filename)
    
      # set source id
      workflow.source = source_record_id
    
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
  
end