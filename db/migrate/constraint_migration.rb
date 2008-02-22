class ConstraintMigration < ActiveRecord::Migration
  
  # Creates a foreign key constraint
  def self.create_constraint(table, foreign_table, local_key = nil, foreign_key = nil)
    local_key ||= "#{foreign_table.singularize}_id"
    foreign_key ||= "id"
    if(ENV['noconstraints'] != 'yes')
      puts "Creating foreign key constraint on #{table}. Try 'noconstraints=yes' if this fails."
      execute "alter table #{table} add constraint #{table}_to_#{foreign_table} foreign key (#{local_key}) references #{foreign_table}(#{foreign_key})"
    else
      puts "Ignoring foreign key constraint"
    end
  end
  
  # Removes a foreign key constraint
  def self.remove_constraint(table, foreign_table)
    if(ENV['noconstraints'] != 'yes')
      puts "Removing foreign key constraint on #{table}. Try 'noconstraints=yes' if this fails."
      execute "alter table #{table} drop foreign key #{table}_to_#{foreign_table}"
    else
      puts "Not removing foreign key constraint for #{table}"
    end
  end
end
