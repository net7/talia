# main class for Wizard Widget
class WizardWidget < Widgeon::Widget
  
  attr_accessor :wizard_name, :wizard_title, :wizard_directory, :wizard_steps
  
  # Initialization method
  # * wizard_options[:model]: model for current wizard.
  # * wizard_options[:controller]: controller that will receive final post
  # * wizard_options[:action]: action that will receive final post
  def on_init
    # check parameters
    if @wizard_options[:model].nil? || @wizard_options[:controller].nil? || @wizard_options[:action].nil?
      raise "Some parameter is not present. Please set @wizard_options => {:model => YourModelClass, :controller => Controller, :action => Action}."
    end
    
    # load configuration
    load_configuration(@wizard_options[:model], @wizard_options[:controller], @wizard_options[:action])
    
    # process submission
    process_submission

    #    if is_callback? && !step.nil?
    #      @wizard_current_step = step.to_i
    #    else
    #      @wizard_current_step = 0
    #    end
    #    
    #    puts @wizard_options[:model].a
    #    
    #    @wizard_model = @wizard_options[:model] #WizardModel.new
  end

  # get controller for submission
  def wizard_controller
    if current_step <= length
      params[:controller]
    else
      @wizard_controller
    end
  end
  
  # set controller for submission
  def wizard_controller=(value)
    @wizard_controller=value
  end
  
  # get action for submission
  def wizard_action
    if current_step <= length
      params[:controller]
    else
      @wizard_action
    end
  end
  
  # set action for submission
  def wizard_action=(value)
    @wizard_action=value
  end

  # get model
  def wizard_model
    widget_session[:model]
  end
  
  # set model
  def wizard_model=(value)
    widget_session[:model] = value
  end
    
  # get total steps number
  def length
    @wizard_steps.length
  end
  
  # get current step hash
  def current_step_hash
    @wizard_steps[current_step - 1]
  end
  
  # get current step number
  def current_step
    widget_session[:current_step] || 1
  end
  
  # set current step number
  def current_step=(value)
    widget_session[:current_step]=value
  end
  
  # get model name in tableized form
  def wizard_model_tableized
    self.wizard_model.class.to_s.tableize.to_sym
  end
  
  # create new step list
  # * steps: steps array.
  # * current_step: current step number.
  # * prefix: prefix
  # * postfix: postfix
  def step_list(steps, current_step, prefix, postfix)
    # initialize result string
    result = ""
    # create the list of steps. Current step have bold attribute.
    steps.each_with_index { |step, index|  
      if index != (current_step - 1)
        result << "#{prefix}#{step[:name]}#{postfix}"
      else
        result << "#{prefix}<b>#{step[:name]}</b>#{postfix}"
      end
    }
    # add finish step
    if current_step != self.length + 1
      result << "#{prefix}Finish#{postfix}"
    else
      result << "#{prefix}<b>Finish</b>#{postfix}"
    end

    # return result
    return result
  end
  
  # create finish table
  def wizard_finish_table
    # initialize result string
    result = ""
    # initialize file counter
    files = []
    # create table rows
    self.wizard_model.attributes.each { |attribute|
      if attribute[0].match("file").nil?
        result << "<tr><td>"
        result << attribute[0]
        result << "</td><td>"
        result << attribute[1]
        result << "</td></tr>"
      else
        files << attribute[1] if attribute[0].match(/file(_\d+_original_filename|_original_filename)/)
      end
    }
    
    # add file counter to string
    result << "<tr><td>Files to submit</td><td>#{files.join(', ')}</td></tr>" unless files == 0
    # return table rows
    return result
  end
  
  # add hidden field for final submission
  def wizard_hidden_field_for_submission
    self.wizard_model.attributes.collect { |attribute|
      hidden_field(self.wizard_model_tableized, attribute[0], {:value => attribute[1]})
    }
  end

  # return error messages if present
  def wizard_error_message
    message = self.wizard_model.errors.full_messages.collect {|msg| msg + '<br />'} unless self.wizard_model.errors.empty?
    return message
  end
  
  # return a text field
  # * field: wizard field
  # * options: text field options
  def wizard_text_field(field, options = {})
    # set value
    options[:value] = self.wizard_model[field]
    
    #return a text field
    return text_field(self.wizard_model_tableized, field, options)
  end
  
  # return a file field
  # * field: wizard field
  # * options: file field options
  def wizard_file_field(field, options = {})
    # return a file field
    return file_field(self.wizard_model_tableized, field, options)
  end
  
  # return a check box
  # * field: wizard field
  # * options: check box options
  # * checked_value: checked value
  # * unchecked_value: unchecked value
  def wizard_check_box(field, options = {}, checked_value = "1", unchecked_value = "0") 
    # return a check box
    return check_box(self.wizard_model, field, options, checked_value, unchecked_value)
  end
  
  # return an hidden field
  # * field: wizard field
  # * options: hidden field options
  def wizard_hidden_field(field, options = {}) 
    # set value
    options[:value] = self.wizard_model[field]
    
    # return an hidden field
    return hidden_field(self.wizard_model, field, options)
  end
  
  # return a label field
  # * field: wizard field
  # * text: text
  # * options: label field options
  def wizard_label(field, text = nil, options = {}) 
    # set value
    text = self.wizard_model[field] if text.nil?
    
    # return a label field
    return label(self.wizard_model, field, text, options)
  end
  
  # return a password field
  # * field: wizard field
  # * options: password field options
  def wizard_password_field(field, options = {}) 
    # return a password field
    return password_field(self.wizard_model, field, options)
  end
  
  # return a radio button
  # * field: wizard field
  # * tag_value: value for current radio button
  # * options: radio buttonoptions
  def wizard_radio_button(field, tag_value, options = {})
    # return a radio button
    return radio_button(self.wizard_model, field, tag_value, options)
  end
  
  # return a text area
  # * field: wizard field
  # * options: text area options
  def wizard_text_area(field, options = {})
    # set value
    options[:value] = self.wizard_model[field]
    
    # return a text area
    return text_area(self.wizard_model, field, options)
  end
  
  private
  
  # load configuration for current wizard
  def load_configuration(model, controller, action)
    # set wizard directory
    self.wizard_name = model.wizard_name
    # set wizard title
    self.wizard_title = model.wizard_title
    # set wizard directory, where are stored partial file. Directory must be equal to wizard name
    self.wizard_directory = model.wizard_name
    # load all step for current wizard.
    self.wizard_steps = model.steps
    # set final submission controller
    self.wizard_controller = controller
    # set final submission action
    self.wizard_action = action
    # load model
    self.wizard_model = @wizard_options[:model].new if self.wizard_model.nil?
  end
  
  def reset
    self.wizard_model = @wizard_options[:model].new
    self.current_step = 1
  end
  
  def process_submission
    # check if there are a submission for current wizard
    case params["#{self.wizard_model_tableized}_submission"]
    when nil
      reset
    when "Previous"
      self.current_step -= 1
      wizard_model.current_step -= 1
    when "Next"
      params[self.wizard_model_tableized].each { |field|  
        case field[1]
        when ActionController::UploadedStringIO
          # create a new temp file
          temp_file = Tempfile.new(field[1].original_filename)
          temp_file << field[1].read
          temp_file.close
          self.wizard_model[field[0]] = temp_file.path
          #self.wizard_model[field[0]]  = field[1].read
          # store original filename
          self.wizard_model["#{field[0]}_original_filename"] = field[1].original_filename
          # store file content type
          self.wizard_model["#{field[0]}_content_type"]  = field[1].content_type
        else
          self.wizard_model[field[0]] = field[1]
        end
      }
      
      if self.wizard_model.valid?
        self.current_step += 1 
        self.wizard_model.current_step += 1
      end
    end
  end
  
end
