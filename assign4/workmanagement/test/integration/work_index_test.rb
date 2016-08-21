require 'test_helper'

class WorkIndexTest < ActionDispatch::IntegrationTest
  
  setup do
    load "#{Rails.root}/db/seeds.rb"
  end
  
  test 'index page should display All Works' do
    get '/works'
                              
    assert_response :success
    
    assert response.body.include? 'Work List' 
    assert response.body.include? 'New Work' 
  end
  
  test 'check index after adding valid data' do
    xhr :post, '/works', :work => {name: 'work 1'}
    get '/works'
    
    assert_response :success
    
    assert response.body.include? 'work 1'
  end
  
end
