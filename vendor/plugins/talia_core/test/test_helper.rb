class TestHelper
  
  # connect the database
  def self.db_connect
    dbconfig = YAML::load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(dbconfig["test"])
    ActiveRecord::Base.logger = Logger.new(File.open('test/database.log', 'a'))
  end
  
end