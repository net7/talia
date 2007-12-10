# 
# This are the methods to set up the commands for the talia command line tool.
# 
module TaliaCommandLine
  
  # Hash with the command line commands
  @commands = {}

  # Set command description
  def self.desc(description)
    @description = description
  end

  # Create a new command for the command line
  def self.command(name, &block)
    description = @description ? @description : ""
    @commands[name.to_sym] = [ description, block ]
  end

  # Run this to iterate through all the commands. This will pass the following
  # parameters to the block: command name, description
  def self.each(&block)
    @commands.each do |key, value|
      block.call(key, value[0], value[1])
    end
  end

  # Returns true if the command exists
  def self.command?(command)
    command && @commands[command.to_sym] != nil 
  end

  # Run the given command
  def self.run_command(command, *options)
    raise(RuntimeError, "Command does not exist: #{command}") unless @commands[command.to_sym]
    @commands[command.to_sym][1].call(*options)
  end

end
