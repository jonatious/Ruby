class CreateSampleLogin < ActiveRecord::Migration
  def up
    Customer.create(:username => 'tempuser',:password => 'password',:first_name => 'Temp', :last_name => 'User', :email => 'tempuser@bidding.com')
  end
  
  def down
    Customer.find_by_username('tempuser').destroy
  end
end
