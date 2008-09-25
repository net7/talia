require File.dirname(__FILE__) + '/config_file'

module TaliaUtil
  module Configuration
    
    # This contains some special methods for database config files
    class DatabaseConfig < ConfigFile
      
      def initialize(template)
        @environments = ['test', 'development', 'production']
        super
      end
      
      # Set the credentials for all environments
      def set_credentials(db_user, db_pass)
        @environments.each do |env| 
          @config_doc[env]['username'] = db_user
          @config_doc[env]['password'] = db_pass
        end
      end
      
      # Sets the database adapter for all environments
      def set_adapter(db_adapter)
        @environments.each { |env| @config_doc[env]['adapter'] = db_adapter }
      end
      
      # Sets the database names based on the given application name
      def set_database_names(app_name)
        @environments.each { |env| @config_doc[env]['database'] = "#{app_name}_#{env}" }
      end
      
      # Sets the socket file for the db
      def set_socket(socket)
        @environments.each { |env| @config_doc[env]['socket'] = socket  }
      end
      
    end
    
  end
end
