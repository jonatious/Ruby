require 'test_helper'

class AuctionItemsTest < ActionDispatch::IntegrationTest

  setup do
    Customer.create(:username => 'tempuser1',:password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser1@bidding.com')
  end
  
  test 'validate login goes to profile page' do
    post '/customers/validate_login', {:username => 'tempuser1', :password => 'password'}
  
    assert_redirected_to profile_customers_path
    
    get '/customers/profile'
    assert response.body.include? 'Hello Temp User' 
  end
  
  test 'create item page' do
    post '/customers/validate_login', {:username => 'tempuser1', :password => 'password'}
    
    xhr :get, '/auction_items/new'
    assert response.body.include? 'Create Auction Item' 
  end
end
