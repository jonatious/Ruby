class AddNameToAuctionItem < ActiveRecord::Migration
  def change
    add_column :auction_items, :name, :string
    add_column :auction_items, :state, :string
  end
end
