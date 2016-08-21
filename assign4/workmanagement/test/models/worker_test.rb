require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  
  setup do
    @worker = Worker.new(first_name: 'Jill', last_name: 'Mark')
  end
  
  test "first name need not be unique" do
    @worker.first_name = workers(:one).first_name
    assert @worker.valid?
  end
  
  test "last name need not be unique" do
    @worker.last_name = workers(:one).last_name
    assert @worker.valid?
  end
  
  test "first name and last name together should be unique" do
    @worker.first_name = workers(:one).first_name
    @worker.last_name = workers(:one).last_name
    assert !@worker.valid?
    assert_equal 'First name and Last name have already been taken', @worker.errors.full_messages.first
  end
  
  test "first name should be present" do
    @worker.first_name = ''
    assert !@worker.valid?
    assert_equal "First name can't be blank", @worker.errors.full_messages.first
  end
  
  test "last name should be present" do
    @worker.last_name = ''
    assert !@worker.valid?
    assert_equal "Last name can't be blank", @worker.errors.full_messages.first
  end
  
end
