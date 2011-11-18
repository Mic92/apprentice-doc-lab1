class CreateIhks < ActiveRecord::Migration
  def change
    create_table :ihks do |t|
      t.string :name

      t.timestamps
    end
  end
end
