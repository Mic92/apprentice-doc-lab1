class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :role
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
    add_index :users, :role_id
  end
end
