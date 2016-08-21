class Bid < ActiveRecord::Base
  
  belongs_to :customer
  belongs_to :auction_item
end
