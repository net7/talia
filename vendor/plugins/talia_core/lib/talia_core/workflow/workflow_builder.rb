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
    # * options: options hash. ':filename' => file to load, ':name' => configuration name to laod
    #
    # filename cannot contain extension, e.g. 'my_file' ('.', '/', '\' aren't permitted)
    def self.load_xml(source_record_id, options = {})
      
      # if filename is nil, use default workflow
      if options[:filename].nil?
        file = File.join(TALIA_ROOT, "config", "workflow", "default.xml")
      else
        # check filename syntax
        if options[:filename].include?(".") || options[:filename].include?("/") || options[:filename].include?("\\")
          raise "Filename cannot contain '.', '/' or '\\'"
        end
        
        file = File.join(TALIA_ROOT, "config", "workflow", options[:filename] + ".xml")
      end
      
      # load xml file
      xml_file = File.new(file)
      xml_data = REXML::Document.new xml_file
    
      # get workflow configuration by name
      if (options[:name].nil?)
        workflow_configuration = xml_data.elements["//root/workflow"]
      else
        workflow_configuration = xml_data.elements["//root/workflow[@name='#{options[:name]}']"]
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
    # * options: options hash. ':filename' => file to load
    #
    # filename cannot contain extension, e.g. 'my_file' ('.', '/', '\' aren't permitted)
    def self.load_dsl(source_record_id, options = {})
      
      # if filename is nil, use default workflow
      if options[:filename].nil?
        file = File.join(TALIA_ROOT, "config", "workflow", "default.rb")
      else
        # check filename syntax
        if options[:filename].include?(".") || options[:filename].include?("/") || options[:filename].include?("\\")
          raise "Filename cannot contain '.', '/' or '\\'"
        end
        
        file = File.join(TALIA_ROOT, "config", "workflow", options[:filename] + ".rb")
      end
      
      # build workflow
      workflow = instance_eval(File.read(file))
    
      # set source id
      workflow.source = source_record_id
    
      # return workflow
      return workflow
    end
  
    # load workflow from xml file
    # * source_record_id: source id
    # * options: options hash. ':filename' => file to load, ':name' => configuration name to laod
    #
    # filename cannot contain extension, e.g. 'my_file' ('.', '/', '\' aren't permitted)
    def self.load_yml(source_record_id, options = {})
      
      # if filename is nil, use default workflow
      if options[:filename].nil?
        file = File.join(TALIA_ROOT, "config", "workflow", "default.yml")
      else
        # check filename syntax
        if options[:filename].include?(".") || options[:filename].include?("/") || options[:filename].include?("\\")
          raise "Filename cannot contain '.', '/' or '\\'"
        end
        
        file = File.join(TALIA_ROOT, "config", "workflow", options[:filename] + ".yml")
      end
      
      # load yml file
      yml_file = YAML::load_file(file)
      
      # get workflow configuration
      if options[:name].nil?
        workflow_configuration = yml_file['default']
      else
        workflow_configuration = yml_file[options[:name]]
      end
      
      # read all workflow step
      workflow_configuration.each { |item|  
        # get step
        step = item['step']
        # add step elements to transitions array
        @transitions << [step[0].to_s.to_sym, step[1].to_s.to_sym, step[2].to_s.to_sym]
      }

      # create new workflow and set source id
      workflow = self.workflow
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