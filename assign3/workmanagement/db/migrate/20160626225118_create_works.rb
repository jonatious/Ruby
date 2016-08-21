class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :name
      t.integer :work_status_id

      t.timestamps null: false
    end
  end
end
