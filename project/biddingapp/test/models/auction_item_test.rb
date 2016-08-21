require 'test_helper'

class AuctionItemTest < ActiveSupport::TestCase

  setup do
    @auction_item = AuctionItem.new(:name => 'Item 1', :description => 'Item 1 desc', :highest_bid => 4.5, :auction_days => 1, :sold_y_n => 'No')
  end

  test "Name can not be or empty" do
    @auction_item.name = ''
    assert !@auction_item.valid?
    assert_equal "Name can't be blank", @auction_item.errors.full_messages.first
  end

  test "Bid can not be or empty" do
    @auction_item.highest_bid = ''
    assert !@auction_item.valid?
    assert_equal "Bid can't be blank", @auction_item.errors.full_messages.first
  end

  test "Auction days can not be or empty" do
    @auction_item.auction_days = ''
    assert !@auction_item.valid?
    assert_equal "Auction days can't be blank", @auction_item.errors.full_messages.first
  end

  test "Bid should be a number" do
    @auction_item.highest_bid = '23ads'
    assert !@auction_item.valid?
    assert_equal "Bid is not a number", @auction_item.errors.full_messages.first
  end

  test "Auction days should be a number" do
    @auction_item.auction_days = '23ads'
    assert !@auction_item.valid?
    assert_equal "Auction days is not a number", @auction_item.errors.full_messages.first
  end
end