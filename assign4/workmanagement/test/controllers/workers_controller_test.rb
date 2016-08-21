require 'test_helper'

class WorkersControllerTest < ActionController::TestCase
  
  setup do
    load "#{Rails.root}/db/seeds.rb"
  end
  
  test 'assigns all_workers and renders index' do
    get :index
    assert_equal 1, assigns(:all_workers).count
    assert_response :success
    assert_template :index
  end
  
  test 'flash message when no workers found' do
    Worker.delete_all
    get :index
    assert_equal 'No Workers Found', flash[:alert]
  end
  
  test 'check index after adding new data' do
    Worker.create(:first_name => 'Jony', :last_name => 'Mike')
    get :index
    assert_equal 2, assigns(:all_workers).count
    assert_response :success
    assert_template :index
  end
  
  test 'create saves worker to the database' do             
    assert_difference 'Worker.count', 1 do
      xhr :post, :create, :worker => {:first_name => 'Jony', :last_name => 'Mike'}
    end
  end
  
  test 'invalid create renders error' do
    xhr :post, :create, :worker => {:first_name => '', :last_name => 'Mike'}
    
    last_work = Worker.last
    
    assert_not_nil assigns(:worker).errors
    assert_response :success
    assert_template :error
  end
  
  test 'show should return success' do
    get :show, :id => workers(:one).id
    assert_response :success
  end
  
  test 'show should store id in session' do
    get :show, :id => workers(:one).id
    assert_equal workers(:one).id, session[:worker_id]
  end
  
  test 'assign redirects to show' do
    get :show, :id => workers(:one).id
    get :assign, {:work_id => works(:one).id}
    
    assert_redirected_to "/workers/#{workers(:one).id}"
    assert_equal "Assigned #{works(:one).name} to #{workers(:one).first_name} #{workers(:one).last_name}", flash[:notice]
  end

end
