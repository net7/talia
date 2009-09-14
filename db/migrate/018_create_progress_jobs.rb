class CreateProgressJobs < ActiveRecord::Migration
  def self.up
    create_table "progress_jobs", :force => true do |t|
      t.integer :job_id
      t.integer :processed_count, :null => false
      t.integer :item_count, :null => false
      t.timestamp :started_at
      t.string :progress_message
    end

    # Create the index 
    add_index :progress_jobs, :job_id, :unique => true
  end

  def self.down
    drop_table "progress_jobs"
  end
end
