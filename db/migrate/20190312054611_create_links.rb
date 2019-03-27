class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :destination, :null => false
      t.string :short_code, :null => false
      t.string :admin_code, :null => false
      t.integer :use_count, :default => 0, :null => false
      t.jsonb :user_agents, :default => {}
      t.jsonb :day_of_week, :default => {}
      t.jsonb :hour_of_day, :default => {}
      t.timestamp :expired_at, :default => nil

      t.timestamps
    end

    add_index :links, :short_code
    add_index :links, :admin_code
    add_index :links, :user_agents
    add_index :links, :day_of_week
    add_index :links, :hour_of_day
  end
end
