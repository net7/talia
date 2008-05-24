class WizardModel < ActiveRecord::Base
  # define class as abstract
  self.abstract_class = true
  
  # initialize current model
  def initialize
    super
    @current_step = 1
  end
  
  # get or set wizard name.
  # name is also used for identify partial directory for wizard widget.
  def self.wizard_name(value = nil)
    if value.nil?
      @wizard_name
    else
      @wizard_name = value
    end
  end
  
  # get or set wizard title
  def self.wizard_title(value = nil)
    if value.nil?
      @wizard_title
    else
      @wizard_title = value
    end
  end
  
  # get all steps
  def self.steps
    @steps
  end

  # add a new step to current wizard model
  def self.step(name, partial)
    @steps = [] if @steps.nil?
    @steps << {:name => name, :partial => partial}
    
    yield if block_given?
  end
  
  # get current step number
  def current_step
    @current_step
  end
  
  # set current step number
  def current_step=(value)
    @current_step = value
  end
  
  # check if it is the current step
  def current_step?
    current_step == step
  end
  
  def self.validates_acceptance_of(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attr_names, conditions)
  end
  
  def self.validates_associated(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attr_names, conditions)    
  end

  def self.validates_confirmation_of(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attr_names, conditions)  
  end
  
  def self.validates_each(*attrs)
    conditions = self.add_current_step_check_for_validation(attrs)
    super(attrs, conditions)
  end
  
  def self.validates_exclusion_of(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attrs, conditions)
  end
 
  def self.validates_format_of(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attr_names, conditions)
  end
    
  def self.validates_inclusion_of(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attr_names, conditions)
  end
  
  def self.validates_length_of(*attrs)
    conditions = self.add_current_step_check_for_validation(attrs)
    super(attrs, conditions)
  end
  
  def self.validates_numericality_of(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attr_names, conditions)
  end
  
  def self.validates_presence_of(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attr_names, conditions)
  end

  def self.validates_uniqueness_of(*attr_names)
    conditions = self.add_current_step_check_for_validation(attr_names)
    super(attr_names, conditions)
  end  
  
  
  private
  
  def self.add_current_step_check_for_validation(attr_names)
    # extract options
    configuration = attr_names.extract_options!
    current_step_value = @steps.length
   
    # override condition
    configuration[:if] = Proc.new {|model| current_step_value <= model.current_step}
    
    return configuration
  end

  
end
