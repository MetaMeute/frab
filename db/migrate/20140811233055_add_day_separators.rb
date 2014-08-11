class AddDaySeparators < ActiveRecord::Migration
  def change
    create_table :day_separators do |t|
      t.integer :day_id, :null => false
      t.datetime :time, :null => false
    end
  end
end
