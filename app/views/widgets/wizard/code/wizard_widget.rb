require File.join(File.dirname(__FILE__), 'wizard_model.rb')

# main class for Wizard Widget
class WizardWidget < Widgeon::Widget
  # Initialization method
  # * wizard_options[:name]: wizard configuration name (if name is nil, the default configuration is loaded)
  # * wizard_options[:controller]: controller that will receive the post
  # * wizard_options[:action]: action that will receive the post
  def on_init
    # load configuration
    widget_session[:name] = @wizard_options[:name] unless @wizard_options.nil?
    load_configuration(widget_session[:name])
    
    if is_callback? && !step.nil?
      @wizard_current_step = step.to_i
    else
      @wizard_current_step = 0
    end
    
    @wizard_model = WizardModel.new
  end
  
  # get all steps
  def steps
    @wizard_steps
  end
  
  # get total steps number
  def length
    @wizard_steps.length
  end
  
  # get current step number
  def current_step
    @wizard_current_step
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
      if index != current_step
        result << "#{prefix}#{step['name']}#{postfix}"
      else
        result << "#{prefix}<b>#{step['name']}</b>#{postfix}"
      end
    }
    # return result
    return result
  end

  private
  
  # load configuration for current wizard
  def load_configuration(name = nil)
    # save wizard name
    @wizard_name = name || 'default'
    # load configuration block
    wizard_configuration = @config_hash[@wizard_name]
    # load wizard title
    @wizard_title = wizard_configuration['title']
    # load wizard directory, where are stored partial file. Directory must be equal to wizard name
    @wizard_directory = name || 'default'
    # load all step for current wizard.
    @wizard_steps = wizard_configuration['steps']
  end

  callback :wizard_move_step do |page|
    @wizard_current_step = step
    # hide all step
    page.hide( "wizard_#{wizard_name}_step_#{previous_step}")
    # show current step
    page.show( "wizard_#{wizard_name}_step_#{step}")
    # update step list
    page.replace "wizard_#{wizard_name}_steps_list", partial('wizard_steps', :locals => {:steps =>  steps, :current_step => step, :wizard_name => wizard_name})
  end
  
end
