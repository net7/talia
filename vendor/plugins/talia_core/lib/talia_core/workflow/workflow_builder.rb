require 'ostruct'
require 'rexml/document'
require 'workflow/workflow'

module TaliaCore
  
  # Workflow Builder class
  #
  # Example:
  # 
  # workflow1 = WorkflowBuilder.workflow do
  #   WorkflowBuilder.step "submitted","review","reviewed"
  #   WorkflowBuilder.step "reviewed","publish","published"
  #   WorkflowBuilder.step "published", "auto","published"
  # end
  class WorkflowBuilder
  
    @transitions = []
  
    # create new workflow
    def self.workflow
      yield if block_given?
      return Workflow.new(@transitions)
    end
  
    # load workflow from xml file
    # * source_record_id: source id
    # * filename: filename to load without extension, e.g. 'my_file' ('.', '/', '\' aren't permitted)
    # * name: load workflow by name (optional)
    def self.load_xml(source_record_id, filename = nil, name = nil)
      
      # if filename is nil, use default workflow
      if filename.nil?
        file = File.join(TALIA_ROOT, "config", "workflow", "default.xml")
      else
        # check filename syntax
        if filename.include?(".") || filename.include?("/") || filename.include?("\\")
          raise "Filename cannot contain '.', '/' or '\\'"
        end
        
        file = File.join(TALIA_ROOT, "config", "workflow", filename + ".xml")
      end
      
      # load xml file
      xml_file = File.new(file)
      xml_data = REXML::Document.new xml_file
    
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
    # * filename: filename to load without extension, e.g. 'my_file' ('.', '/', '\' aren't permitted)
    def self.load_dsl(source_record_id,filename = nil)
      
      # if filename is nil, use default workflow
      if filename.nil?
        file = File.join(TALIA_ROOT, "config", "workflow", "default.rb")
      else
        # check filename syntax
        if filename.include?(".") || filename.include?("/") || filename.include?("\\")
          raise "Filename cannot contain '.', '/' or '\\'"
        end
        
        file = File.join(TALIA_ROOT, "config", "workflow", filename + ".rb")
      end
      
      # build workflow
      workflow = instance_eval(File.read(file))
    
      # set source id
      workflow.source = source_record_id
    
      # return workflow
      return workflow
    end
  
    # Add step to workflow
    # * origin_state: begin state of transition
    # * event: event that execute the transition
    # * destination_state: end state of transition
    def self.step(origin_state, event, destination_state)
      @transitions << [origin_state.to_sym, event.to_sym, destination_state.to_sym]
    end
  
  end
  
end