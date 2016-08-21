require 'test_helper'

class CustomerPageTest < ActionDispatch::IntegrationTest
  setup do
    Customer.create(:username => 'tempuser1',:password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser1@bidding.com')
    post '/customers/validate_login', {:username => 'tempuser1', :password => 'password'}
  end
  
  test 'update profile page' do
    xhr :get, '/customers/change_password'
    assert response.body.include? 'Change Password' 
  end
  
  test 'display items page' do
    xhr :get, '/customers/display_items'
    assert response.body.include? 'No items found' 
  end
  
  test 'display bids page' do
    xhr :get, '/customers/display_bids'
    assert response.body.include? 'No bids found' 
  end
  
  test 'search page' do
    xhr :get, '/customers/search'
    assert response.body.include? 'Search' 
  end
end
