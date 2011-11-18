class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.references :job
      t.references :ihk
      t.references :code

      t.timestamps
    end
    add_index :templates, :job_id
    add_index :templates, :ihk_id
    add_index :templates, :code_id
  end
end
