class AuctionItem < ActiveRecord::Base
  validates_presence_of :name, :highest_bid, :auction_days
  validates_numericality_of :highest_bid, :auction_days
  
  belongs_to :customer
  has_many :bids
end