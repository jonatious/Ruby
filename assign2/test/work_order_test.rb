require 'minitest/autorun'
require 'date'
require './src/db'
require './src/work_order'

class WorkOrdererTest < MiniTest::Unit::TestCase
  def setup
    @work_order = WorkOrder.new(work_details: 'Watch paint dry', creation_date: Date.new(2016, 06, 01), status: 'created', status_update_date: Date.new(2016, 06, 18))
  end                                                        
  
  def test_work_order_is_valid
    assert @work_order.valid?
  end
  
  def test_work_details_required
    @work_order.work_details = ''

    assert !@work_order.valid?
    assert_equal ["Work details can't be blank"], @work_order.errors.full_messages
  end

  def test_creation_date_required
    @work_order.creation_date = ''

    assert !@work_order.valid?
    assert_equal ["Creation date can't be blank"], @work_order.errors.full_messages
  end    
  
  def test_status_may_be_created
    @work_order.status = 'created'

    assert @work_order.valid?
  end

  def test_status_may_be_in_progress
    @work_order.status = 'in progress'

    assert @work_order.valid?
  end

  def test_status_may_be_review
    @work_order.status = 'review'

    assert @work_order.valid?
  end

  def test_status_may_be_completed
    @work_order.status = 'completed'

    assert @work_order.valid?
  end

  def test_status_arbitrary_string_not_allowed
    @work_order.status = 'slack'

    assert !@work_order.valid?
    assert_equal ["Status is not included in the list"], @work_order.errors.full_messages
  end
  
  def test_status_update_date_required
    @work_order.status_update_date = ''

    assert !@work_order.valid?
    assert_equal ["Status update date can't be blank"], @work_order.errors.full_messages
  end
end
