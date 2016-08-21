class RemoveAddressColumns < ActiveRecord::Migration
  def change
    remove_column :auction_items, :address
    remove_column :auction_items, :city
    remove_column :auction_items, :zipcode
    remove_column :auction_items, :country
    remove_column :auction_items, :state
  end
end
