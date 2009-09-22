class DTH

  class << self
    # Check if the given flag is set on the command line
    def flag?(the_flag)
      ENV[the_flag] && (ENV[the_flag] == "yes" || ENV[the_flag] == "true")
    end
    
    def run_git_command(command)
      command = "#{find_git_binary} #{command}"
      puts "[git] Exececuting #{command}"
      result = system(command)
      raise(RuntimeError, "Could not run: #{command}") unless(result)
    end
    
    def find_git_binary
       ENV['git_path'] ? ENV['git_path'] : `which git`.chop
    end
  end
  
end