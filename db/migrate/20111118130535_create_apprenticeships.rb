class CreateApprenticeships < ActiveRecord::Migration
  def change
    create_table :apprenticeships do |t|
      t.integer :instructor_id
      t.integer :apprentice_id

      t.timestamps
    end
  end
end
