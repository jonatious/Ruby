class AddWorkerToWork < ActiveRecord::Migration
  def change
    add_column :works, :worker_id, :integer
  end
end
