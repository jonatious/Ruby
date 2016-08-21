require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  setup do
    @customer = Customer.new(:username => 'jonatious', :password => 'password', :first_name => 'jony', :last_name => 'hero', :address => '4045 Linkwood Dr', :city => 'Houston', :state => 'TX', :zipcode => 77025, :country => 'USA', :email => 'jonatious@gmail.com')
  end
  
  test "username can not be or empty" do
    @customer.username = ''
    assert !@customer.valid?
    assert_equal "Username can't be blank", @customer.errors.full_messages.second
  end
  
  test "username can not be less than 3 characters" do
    @customer.username = 'ab'
    assert !@customer.valid?
    assert_equal "Username is too short (minimum is 3 characters)", @customer.errors.full_messages.first
  end
  
  test "username can not be greater than 20 characters" do
    @customer.username = 'abcdefghijklmnopqrstuvwxyz'
    assert !@customer.valid?
    assert_equal "Username is too long (maximum is 20 characters)", @customer.errors.full_messages.first
  end
  
  test "username should be unique" do
    @customer.save
    @customer = Customer.new(:username => 'jonatious', :password => 'password', :first_name => 'jony', :last_name => 'hero', :address => '4045 Linkwood Dr', :city => 'Houston', :state => 'TX', :zipcode => 77025, :country => 'USA', :email => 'jony@gmail.com')
    assert !@customer.valid?
    assert_equal "Username has already been taken", @customer.errors.full_messages.first
  end
  
  test "email should be unique" do
    @customer.save
    @customer = Customer.new(:username => 'jony', :password => 'password', :first_name => 'jony', :last_name => 'hero', :address => '4045 Linkwood Dr', :city => 'Houston', :state => 'TX', :zipcode => 77025, :country => 'USA', :email => 'jonatious@gmail.com')
    assert !@customer.valid?
    assert_equal "Email has already been taken", @customer.errors.full_messages.first
  end
  
  test "email should be in correct format" do
    
    @customer.email = 'jonatiousgmail.com'
    assert !@customer.valid?
    assert_equal "Email is invalid", @customer.errors.full_messages.first
    
    @customer.email = 'jonatious@gmailcom'
    assert !@customer.valid?
    assert_equal "Email is invalid", @customer.errors.full_messages.first
  end
  
  test "email can not be or empty" do
    @customer.email = ''
    assert !@customer.valid?
    assert_equal "Email can't be blank", @customer.errors.full_messages.second
  end
  
  test "first name can not be or empty" do
    @customer.first_name = ''
    assert !@customer.valid?
    assert_equal "First name can't be blank", @customer.errors.full_messages.first
  end
  
  test "last name can not be or empty" do
    @customer.last_name = ''
    assert !@customer.valid?
    assert_equal "Last name can't be blank", @customer.errors.full_messages.first
  end
end
