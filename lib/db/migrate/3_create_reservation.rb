class CreateReservation < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :apartment_id, null: false
      t.integer :uid
      t.date :from, null: false
      t.date :to, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :state, null: false

      t.timestamps
    end
    
    add_index :reservations, :uid, unique: true
  end
end
