class CreateAnotherSampleLogin < ActiveRecord::Migration
  def up
    Customer.create(:username => 'tempuser1',:password => 'password',:first_name => 'Temp', :last_name => 'User1', :email => 'tempuser1@bidding.com')
  end
  
  def down
    Customer.find_by_username('tempuser1').destroy
  end
end
