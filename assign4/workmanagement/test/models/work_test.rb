require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  
  setup do
    @work = Work.new(name: 'new work')
    load "#{Rails.root}/db/seeds.rb"
  end
  
  test "name should be present" do
    @work.name = ''
    assert !@work.valid?
    assert_equal "Name can't be blank", @work.errors.full_messages.first
  end
  
  test "work status is 'Created' for new works" do
    @work.save
    assert_equal 'Created', @work.work_status.status
  end
end
