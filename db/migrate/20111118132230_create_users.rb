class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :forename
      t.string :zipcode
      t.string :street
      t.string :city
      t.string :email
      t.string :hashed_password
      t.string :salt
      t.boolean :deleted
      t.integer :instructor_id

      t.timestamps
    end
  end
end
