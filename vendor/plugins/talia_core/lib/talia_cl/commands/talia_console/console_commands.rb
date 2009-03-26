# This adds the console commands for the talia console

module TaliaCommandLine

  # Array with command descriptions
  @console_commands = Array.new

  # Add a new console command
  def self.console(command, &command_block)
    # Add the description
    description = @desc ? @desc : "Generic command: #{command}"
    @desc = nil
    @console_commands << [command.to_s, description]

    command = command.to_sym

    (class << MAIN_OBJECT; self; end).class_eval do
      define_method(command, command_block)
    end
  end

  # Add an instance variable
  def self.to_var(name, value)
    (class << MAIN_OBJECT; self; end).class_eval do
      raise(RuntimeError, "Method already defined: #{name}") if(method_defined?(name)) 
      define_method(name) { value }
    end
    value
  end
  
  # Returns the defined console commands
  def self.console_commands
    @console_commands
  end

end

