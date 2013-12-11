class CreateRezAddress < ActiveRecord::Migration
  def change
    create_table :rez_addresses do |t|
      t.text :building_number
      t.text :street_name
      t.text :secondary_address
      t.text :city
      t.text :state
      t.text :zip_code
      t.text :county
      t.text :country
    end
  end
end
