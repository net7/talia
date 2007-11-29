# A generator for the database tables that the Talia core uses
class TaliaMigrationsGenerator < Rails::Generator::Base
  
  def manifest
    
    migrations = [
      "create_source_records",
      "create_dirty_relation_records",
      "create_type_records",
      "create_data_records"
    ]
    
    record do |m|
      migrations.each { |mig| m.migration_template(mig, "db/migrate", :migration_file_name => mig) }
    end
  end
end
