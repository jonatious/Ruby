class CreateWorkStatuses < ActiveRecord::Migration
  def change
    create_table :work_statuses do |t|
      t.string :status

      t.timestamps null: false
    end
  end
end
