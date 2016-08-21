require 'test_helper'

class WorksControllerTest < ActionController::TestCase
  
  setup do
    load "#{Rails.root}/db/seeds.rb"
  end
  
  test 'assigns all_works and renders index' do
    get :index
    assert_equal 1, assigns(:all_works).count
    assert_response :success
    assert_template :index
  end
  
  test 'flash message when no works found' do
    Work.delete_all
    get :index
    assert_equal 'No Works Found', flash[:alert]
  end
  
  test 'check index after adding new data' do
    Work.create(:name => 'work temp')
    get :index
    assert_equal 2, assigns(:all_works).count
    assert_response :success
    assert_template :index
  end
  
  test 'create saves work to the database' do             
    assert_difference 'Work.count', 1 do  
      xhr :post, :create, :work => {name: 'new work'}
    end
  end
  
  test 'invalid create renders error' do
    xhr :post, :create, :work => {name: ''}
    
    last_work = Work.last
    
    assert_not_nil assigns(:work).errors
    assert_response :success
    assert_template :error
  end
  
  test 'show should return success' do
    get :show, :id => works(:one).id
    assert_response :success
  end
  
  test 'show should store id in session' do
    get :show, :id => works(:one).id
    assert_equal works(:one).id, session[:work_id]
  end
  
  test 'assign redirects to show' do
    get :show, :id => works(:one).id
    get :assign, {:worker_id => workers(:one).id}
    
    assert_redirected_to "/works/#{works(:one).id}"
    assert_equal "Assigned #{works(:one).name} to #{workers(:one).first_name} #{workers(:one).last_name}", flash[:notice]
  end
  
  test 'set completed action redirects to show' do
    get :show, :id => works(:one).id
    get :set_completed
    
    assert_redirected_to "/works/#{works(:one).id}"
  end
  
end
