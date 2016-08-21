require 'test_helper'

class AuctionItemsControllerTest < ActionController::TestCase

  setup do
    session[:username] = 'username1';
    xhr :post, :create, :auction_item => {:name => 'item 1', :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3}
    session[:item_id] = AuctionItem.last.id
  end
  
  test 'new assigns auction item and renders new' do
    xhr :get, :new
    
    assert_not_nil assigns(:auction_item)
    assert_response :success
    assert_template :new
  end

  test 'create saves auction item to the database' do
    assert_difference 'AuctionItem.count', 1 do    
      xhr :post, :create, :auction_item => {:name => 'item 1', :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3}
    end
    
    assert_response :success
  end

  test 'create saves auction item with sold as No' do
    @auction_item = AuctionItem.last
    assert_equal 'No', @auction_item.sold_y_n
  end

  test 'valid create saves auction item and renders new' do
    xhr :post, :create, :auction_item => {:name => 'item 1', :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3}

    assert_template :new
  end

  test 'valid create generates flash notice' do
    xhr :post, :create, :auction_item => {:name => 'item 1', :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3}

    assert_equal 'Successfully created item', flash[:notice]
  end

  test 'invalid create saves auction item and renders profile' do
    xhr :post, :create, :auction_item => {:name => '', :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3}

    assert_template :new
  end

  test 'edit item renders edit' do
    xhr :get, :edit, :id => AuctionItem.last.id
    
    assert_not_nil assigns(:auction_item)
    assert_response :success
    assert_template :edit
  end
  
  test 'valid update saves auction item and renders profile' do
    xhr :put, :update, {:id => 1, :auction_item => {:name => 'item 2', :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3}}

    assert_template 'customers/display_items'
    assert_equal 'Successfully Updated Item', flash[:notice]
  end
  
  test 'invalid update when bid is lesser than existing bid' do
    session[:username] = 'username2';
    xhr :post, :update_bid, :bid => 6
    session[:username] = 'username1';
    xhr :put, :update, {:id => 1, :auction_item => {:name => 'item 2', :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3}}

    assert_not_nil assigns(:auction_item).errors
    assert_template :edit
    assert_equal 'Bid should be greater than the current bid', assigns(:auction_item).errors.full_messages.first
  end
  
  test 'update to reject bid clears bidder id' do
    session[:username] = 'username2';
    xhr :post, :update_bid, :bid => 6
    session[:username] = 'username1';
    xhr :put, :update, {:id => 1, :auction_item => {:name => 'item 2', :description => 'item 1 desc', :highest_bid => 10, :auction_days => 3}}

    assert_nil assigns(:auction_item).bidder_id
    assert_template 'customers/display_items'
  end
  
  test 'invalid update renders edit' do
    xhr :put, :update, {:id => 1, :auction_item => {:name => '', :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3}}

    assert_template :edit
  end
  
  test 'confirm delete renders confirm_delete' do
    xhr :get, :confirm_delete, :id => 1

    assert_template :confirm_delete
  end
  
  test 'delete renders display_items' do
    xhr :get, :delete

    assert_equal 'Successfully Deleted Item', flash[:notice]
    assert_template 'customers/display_items'
  end
  
  test 'delete reduces database by 1' do
    assert_difference 'AuctionItem.count', -1 do
      xhr :get, :delete
    end

    assert_equal 'Successfully Deleted Item', flash[:notice]
    assert_template 'customers/display_items'
  end
  
  test 'view assigns auction item and bidder is nil and renders view' do
    
    xhr :get, :view
    
    assert_not_nil assigns(:auction_item)
    assert_nil assigns(:bidder)
    assert_response :success
    assert_template :view
  end
  
  test 'view assigns auction item and bidder and renders view after bid' do
    session[:username] = 'username2';
    xhr :post, :update_bid, :bid => 6
    session[:username] = 'username1';
    xhr :get, :view
    
    assert_not_nil assigns(:auction_item)
    assert_not_nil assigns(:bidder)
    assert_response :success
    assert_template :view
  end
  
  test 'valid update_bid assigns bid' do
    
    xhr :post, :update_bid, :bid => 6
    
    assert_response :success
    assert_template :view
    assert_equal 'Bid Successfully Placed!', flash[:notice]
  end
  
  test 'lesser update_bid throws error' do
    
    xhr :post, :update_bid, :bid => 3
    
    assert_response :success
    assert_template :view
    assert_equal 'Bid should be greater than the current bid', assigns(:auction_item).errors.full_messages.first
  end
  
  test 'update_bid increases bid count for first bid' do

    assert_difference 'Bid.count', 1 do    
      xhr :post, :update_bid, :bid => 6
    end
    
    assert_response :success
  end
  
  test 'update_bid doesnt change bid count for update bid' do

    xhr :post, :update_bid, :bid => 6
    assert_difference 'Bid.count', 0 do    
      xhr :post, :update_bid, :bid => 7
    end
    
    assert_response :success
  end
end
