require 'fileutils'

module TaliaCore
  module DataTypes
    
    # This is used for "delayed" copy operations. Basically this will created
    # a file called "delayed_copy.sh" in the RAILS_ROOT, which can later be
    # run as a bash script. This will allow the user to run the
    # copy operation and be potentially faster than using the builtin copy
    # operations (especially using JRuby)
    class DelayedCopier
      
      # Returns (and creates, if necessary) the file to write the delayed 
      # copy operations to
      def self.delayed_copy_file
        @delayed_copy_file ||= begin
          backup_file if(File.exists?(delay_file_name))
          file = File.open(delay_file_name, 'w')
          file.puts('#!/bin/bash')
          file
        end
      end
      
      def self.cp(source, target)
        cp_string = 'cp -v "'
        cp_string << File.expand_path(source)
        cp_string << '" "'
        cp_string << File.expand_path(target)
        cp_string << '"'
        delayed_copy_file.puts(cp_string)
        delayed_copy_file.flush
      end
      
      # Close the delayed copy file
      def self.close
        if(@delayed_copy_file)
          @delayed_copy_file.close
          @delayed_copy_file = nil
        end
      end
      
      private
      
      # The file name for the delayed copy
      def self.delay_file_name
        File.join(RAILS_ROOT, 'delayed_copy.sh')
      end
      
      # Backs up an existing file if necessary
      def self.backup_file
        round = 1
        file_name = 'nil'
        while(File.exists?(file_name = File.join(RAILS_ROOT, "delayed_copy_old_#{round}.sh")))
          round += 1
        end
        FileUtils.mv(delay_file_name, file_name) 
      end
      
    end
    
  end
end