class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.float :amount
      t.integer :customer_id
      t.integer :auction_item_id

      t.timestamps null: false
    end
  end
end
