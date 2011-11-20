class DropApprenticeships < ActiveRecord::Migration
  def up
    drop_table :apprenticeships
  end

  def down
    create_table :apprenticeships do |t|
      t.integer :instructor_id
      t.integer :apprentice_id

      t.timestamps
    end
  end
end
