require 'active_record'

module TaliaUtil
  module Configuration
    
    # This contains some methods to set mysql databases on a production system
    # from scratch. Setting the root password will apply immediately, the SQL
    # operations will be cached and applied in one go.
    class MysqlDatabaseSetup
     
      def initialize
        @sql_statements = []
      end
      
      attr_accessor :host
      attr_accessor :app_name
      attr_accessor :sock
      
      # Set the root user/pw
      def root_credentials(root_user = 'root', root_pw = nil)
        @root_user = root_user
        @root_pw = root_pw
      end
      
      # Set the normal user/pw
      def rails_credentials(rails_user, rails_pw)
        @rails_user = rails_user
        @rails_pw = rails_pw
      end
      
      
      # Assign a new root password
      def assign_root_pw(new_root_pw)
        success = mysqladmin("password #{new_root_pw}")
        @root_pw = new_root_pw if(success)
        success
      end
      
      # Create the given database and set the permssions on it
      def create_database(database)
        raise(ArgumentError, "Credentials incomplete") unless(@rails_user && @rails_pw)
        @sql_statements << "CREATE DATABASE #{database};"
        @sql_statements << "GRANT ALL ON #{database}.* TO '#{@rails_user}'@'#{@host || 'localhost'}' IDENTIFIED BY '#{@rails_pw}'"
      end
      
      # Creates the default databases for the application. You can call back a
      # block for each db to do something depending on the success of the
      # operation
      def create_default_databases
        raise(ArgumentError, "App name not set") unless(@app_name)
        %w(production test development).each do |db_suffix|
          db_name = "#{@app_name}_#{db_suffix}"
          success = create_database(db_name)
        end
      end
      
      # Executes all stored statements
      def execute
        execute_as_root do |connection|
          connection.transaction do
            @sql_statements.each do |statement|
                connection.execute(statement)
            end
          end
        end
      end
      
      private
      
      # Call the mysqladmin command (as root)
      def mysqladmin(command)
        if(@root_pw)
          system("mysqladmin -u #{@root_user} #{command}")
        else
          system("mysqladmin -u #{@root_user} -p#{@root_pw} #{command}")
        end
      end
      
      # Calls sql commands on the database using root credentials. The open
      # database (ActiveRecord) connection will be passed. This will open
      # the given database.
      def execute_as_root(database = nil)
        ActiveRecord::Base.establish_connection(root_con_opts(database))
        yield(ActiveRecord::Base.connection)
        ActiveRecord::Base.remove_connection
      end
      
      # options for root connection
      def root_con_opts(database)
        {
          :adapter => "mysql",
          :host => @host || "localhost",
          :username => @root_user,
          :password => @root_pw,
          :database => database,
          :socket => @sock || '/tmp/mysql.sock'
        }
      end
      
    end
    
  end
end
