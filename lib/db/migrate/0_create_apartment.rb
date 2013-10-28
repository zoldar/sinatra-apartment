class CreateApartment < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.text :name

      t.timestamps
    end
    
    add_index :apartments, :name, unique: true
  end
end
