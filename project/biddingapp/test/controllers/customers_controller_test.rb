require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
    Customer.create(:username => 'tempuser',:password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser@bidding.com')
  end
  
  test 'no login redirects to login from profile' do
    xhr :get, :profile
    assert_redirected_to login_customers_path
  end
  
  test 'no login redirects to login from edit' do
    xhr :get, :edit, :id => 1
    assert_redirected_to login_customers_path
  end

  test 'no login redirects to login from display_items' do
    xhr :get, :display_items
    assert_redirected_to login_customers_path
  end

  test 'no login redirects to login from display_bids' do
    xhr :get, :display_bids
    assert_redirected_to login_customers_path
  end

  test 'no login redirects to login from search' do
    xhr :get, :search
    assert_redirected_to login_customers_path
  end

  test 'no login redirects to login from search_items' do
    xhr :get, :search_items
    assert_redirected_to login_customers_path
  end

  test 'valid login redirects to profile' do
    session[:username] = 'tempuser'
    xhr :get, :login
    assert_redirected_to profile_customers_path
  end

  test 'new assgins customer' do
    get :new
    assert_not_nil assigns(:customer)
    assert_template :new
  end

  test 'create saves customer to the database' do
    assert_difference 'Customer.count', 1 do    
      post :create, :customer => {:username => 'tempuser1',:password => 'password',:confirm_password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser1@bidding.com'}
    end
  end

  test 'valid create redirects to profile with notice' do
    post :create, :customer => {:username => 'tempuser1',:password => 'password',:confirm_password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser1@bidding.com'}

    assert_redirected_to profile_customers_path
    assert_equal 'Welcome to the Bidding Site', flash[:notice]
  end

  test 'invalid create renders new with error' do
    post :create, :customer => {:username => 'tempuser',:password => 'password',:confirm_password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser1@bidding.com'}
    
    assert_not_nil assigns(:customer).errors
    assert_equal 'Username has already been taken', assigns(:customer).errors.full_messages.first
    assert_template :new
    assert_response :success
  end

  test 'password mismatch create renders new with error' do
    post :create, :customer => {:username => 'tempuser1',:password => 'pasword',:confirm_password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser1@bidding.com'}
    
    assert_not_nil assigns(:customer).errors
    assert_equal 'Passwords do not match', assigns(:customer).errors.full_messages.first
    assert_template :new
    assert_response :success
  end

  test 'edit assgins customer' do
    session[:username] = 'tempuser'
    xhr :get, :edit,:id => 0
    assert_not_nil assigns(:customer)
    assert_template :edit
    assert_response :success
  end
  
  test 'valid update saves customer and renders profile' do
    session[:username] = 'tempuser'
    xhr :put, :update, {:id => 1, :customer => {:username => 'tempuser1',:password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser@bidding.com'}}

    assert_template :profile
    assert_equal 'Successfully Updated', flash[:notice]
  end
  
  test 'invalid update renders edit' do
    session[:username] = 'tempuser'
    xhr :put, :update, {:id => 1, :customer => {:username => '',:password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser@bidding.com'}}

    assert_template :edit
    assert_not_nil assigns(:customer).errors
  end

  test 'profile assgins customer' do
    session[:username] = 'tempuser'
    xhr :get, :profile
    
    assert_not_nil assigns(:customer)
    assert_template :profile
    assert_response :success
  end

  test 'logout clears session customer and redirects to login' do
    session[:username] = 'tempuser'
    xhr :get, :logout
    
    assert_nil session[:username]
    assert_redirected_to login_customers_path
    assert_equal 'Logged out Successfully!', flash[:notice]
  end

  test 'update_password validates current password' do
    session[:username] = 'tempuser'
    xhr :post, :update_password, {:current_password => 'pass', :new_password => 'password', :confirm_password => 'password'}
    
    assert_template :change_password
    assert_equal 'Current Password is incorrect', flash[:alert]
  end

  test 'update_password validates password match' do
    session[:username] = 'tempuser'
    xhr :post, :update_password, {:current_password => 'password', :new_password => 'passwsord', :confirm_password => 'password'}
    
    assert_template :change_password
    assert_equal 'Passwords do not match', flash[:alert]
  end

  test 'update_password validates password' do
    session[:username] = 'tempuser'
    xhr :post, :update_password, {:current_password => 'password', :new_password => '', :confirm_password => ''}
    
    assert_template :change_password
    assert_equal 'Password is too short (minimum is 6 characters)', flash[:alert]
  end

  test 'valid pdate_password renders profile' do
    session[:username] = 'tempuser'
    xhr :post, :update_password, {:current_password => 'password', :new_password => 'password', :confirm_password => 'password'}
    
    assert_template :profile
    assert_equal 'Password Changed Successfully', flash[:notice]
  end
  
  test 'display_items assigns all items of user' do
    session[:username] = 'tempuser'
    AuctionItem.create(:name => 'item 1',:customer_id => Customer.last.id, :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3)
    xhr :get, :display_items
    
    assert_not_nil assigns(:items)
    assert_template :display_items
    assert_response :success
  end
  
  test 'display_items errors when no items found' do
    session[:username] = 'tempuser'
    xhr :get, :display_items
    
    assert_equal 'No items found', flash[:alert]
    assert_template :display_items
    assert_response :success
  end
  
  test 'display_bids assigns all items of user' do
    session[:username] = 'tempuser'
    AuctionItem.create(:name => 'item 1',:customer_id => Customer.last.id, :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 3)
    Bid.create(:amount => 5, :customer_id => Customer.last.id, :auction_item_id => AuctionItem.last.id)
    xhr :get, :display_bids

    assert_not_nil assigns(:items)
    assert_template :display_bids
    assert_response :success
  end
  
  test 'display_bids errors when no items found' do
    session[:username] = 'tempuser'
    xhr :get, :display_bids
    
    assert_equal 'No bids found', flash[:alert]
    assert_template :display_bids
    assert_response :success
  end
  
  test 'search renders search' do
    session[:username] = 'tempuser'
    xhr :get, :search
    
    assert_template :search
    assert_response :success
  end
  
  test 'search_items renders search_items' do
    session[:username] = 'tempuser'
    xhr :get, :search_items, {:name => 'item 1'}
    
    assert_not_nil assigns(:items)
    assert_template :search_items
    assert_response :success
  end
  
  test 'empty search_items renders search_items with alert' do
    session[:username] = 'tempuser'
    xhr :get, :search_items, {:name => 'itemew 1',:desc => 'wecd'}
    
    assert_equal 'No items found', flash[:alert]
    assert_not_nil assigns(:items)
    assert_template :search_items
    assert_response :success
  end
  
  test 'update_sold updates to yes after selling' do
    session[:username] = 'tempuser'
    AuctionItem.create(:name => 'item 1',:customer_id => Customer.last.id, :description => 'item 1 desc', :highest_bid => 4.5, :auction_days => 0.0000000001)
    sleep(1)
    xhr :get, :display_items
    
    assert_equal 'Yes', AuctionItem.last.sold_y_n
  end
  
  test 'validate_login renders profile and assigns session' do
    post :validate_login, {:username => 'tempuser', :password => 'password'}
    
    assert_not_nil session[:username]
    assert_equal 'tempuser', session[:username]
    assert_redirected_to profile_customers_path
  end
  
  test 'validate_login redirects to login if password incorrect' do
    post :validate_login, {:username => 'tempuser', :password => 'passwrd'}
    
    assert_redirected_to login_customers_path
    assert_equal 'Password Incorrect', flash[:alert]
  end
  
  test 'validate_login redirects to login if user not found' do
    post :validate_login, {:username => 'tempusdder', :password => 'passwrd'}
    
    assert_redirected_to login_customers_path
    assert_equal 'User not found', flash[:alert]
  end
  
end
