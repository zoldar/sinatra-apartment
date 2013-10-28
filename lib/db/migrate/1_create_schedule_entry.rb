class CreateScheduleEntry < ActiveRecord::Migration

  def change
    create_table :schedule_entries do |t|
      t.integer :apartment_id, null: false
      t.date :from, null: false
      t.date :to, null: false
      t.string :state, null: false
    end
  end
end
