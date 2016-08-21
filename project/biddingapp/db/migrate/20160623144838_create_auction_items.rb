class CreateAuctionItems < ActiveRecord::Migration
  def change
    create_table :auction_items do |t|
      t.integer :customer_id
      t.string :address
      t.string :city
      t.integer :zipcode
      t.string :country
      t.string :description
      t.float :highest_bid
      t.integer :bidder_id
      t.float :auction_days
      t.string :sold_y_n

      t.timestamps null: false
    end
  end
end
