require 'test_helper'

class WorkStatusTest < ActiveSupport::TestCase
  
  setup do
    @workstatus = WorkStatus.new
    load "#{Rails.root}/db/seeds.rb"
  end
  
  test "status Created is in database" do
    @workstatus = WorkStatus.find_by_status('Created')
    assert_not_nil @workstatus
  end
  
  test "status Assigned is in database" do
    @workstatus = WorkStatus.find_by_status('Assigned')
    assert_not_nil @workstatus
  end
  
  test "status Completed is in database" do
    @workstatus = WorkStatus.find_by_status('Completed')
    assert_not_nil @workstatus
  end
  
  test "status can not be random value" do
    @workstatus.status = 'blah'
    assert !@workstatus.valid?
    assert_equal 'Status is not included in the list', @workstatus.errors.full_messages.first
  end
  
  test "status can not be or empty" do
    @workstatus.status = ''
    assert !@workstatus.valid?
    assert_equal "Status can't be blank", @workstatus.errors.full_messages.first
  end
  
  test "status should be unique" do
    @workstatus.status = 'Completed'
    assert !@workstatus.valid?
    assert_equal "Status has already been taken", @workstatus.errors.full_messages.first
  end
  
  test "seed data should insert 3 rows" do
    assert_equal 3, WorkStatus.count
  end
end
