require 'test_helper'

class WorkerIndexTest < ActionDispatch::IntegrationTest
  
  setup do
    load "#{Rails.root}/db/seeds.rb"
  end
  
  test 'index page should display All Works' do
    get '/workers'
                              
    assert_response :success
    assert response.body.include? 'Worker List'
  end
  
  test 'check index after adding valid data' do
    xhr :post, '/workers', :worker => {first_name: 'jony', last_name: 'hero'}
    get '/workers'
    
    assert_response :success
    assert response.body.include? 'jony'
  end
end
