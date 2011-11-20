class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :zipcode
      t.string :street
      t.string :city

      t.timestamps
    end
  end
end
