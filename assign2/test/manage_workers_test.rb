require 'minitest/autorun'
require './src/db'
require './src/manage_workers'

class ManageWorkersTest < MiniTest::Unit::TestCase
  def setup
    @worker = Worker.new(first_name: 'Mary', last_name: 'Poppins')
    @manage_workers = ManageWorkers.new

    @work_order1 = WorkOrder.new(work_details: 'visit banks', creation_date: Date.new(1934, 01, 01), status: 'completed', status_update_date: Date.new(1934, 01, 01))
    @work_order2 = WorkOrder.new(work_details: 'visit places', creation_date: Date.new(1934, 05, 01), status: 'in progress', status_update_date: Date.new(1934, 05, 01))
    @work_order3 = WorkOrder.new(work_details: 'come back', creation_date: Date.new(1943, 01, 01), status: 'created', status_update_date: Date.new(1943, 01, 01))
  end                              

  def test_no_worker_order_on_create
    assert_equal(0, @worker.work_orders.count)
  end
  
  def test_assign_work_order_to_worker
    work_order = WorkOrder.new(work_details: 'visit banks', creation_date: Date.new(1934, 01, 01), status: 'created', status_update_date: Date.new(1934, 01, 01))

    @manage_workers.assign(@worker, work_order)

    assert_equal(1, @worker.work_orders.count)
  end

  def test_check_work_orders
    @manage_workers.assign(@worker, @work_order1)
    @manage_workers.assign(@worker, @work_order2)
    @manage_workers.assign(@worker, @work_order3)

    assert_equal([@work_order1, @work_order2, @work_order3], @worker.work_orders)
  end
  
  def test_get_not_completed_work_orders
    @manage_workers.assign(@worker, @work_order1)
    @manage_workers.assign(@worker, @work_order2)
    @manage_workers.assign(@worker, @work_order3)

    not_completed = @manage_workers.get_not_completed_work_orders(@worker)

    assert_equal([@work_order2, @work_order3], not_completed)
  end
  
  def test_get_work_orders_with_status_completed
    @manage_workers.assign(@worker, @work_order1)
    @manage_workers.assign(@worker, @work_order2)
    @manage_workers.assign(@worker, @work_order3)

    work_orders = @manage_workers.get_work_orders_with_status(@worker, 'completed')

    assert_equal([@work_order1], work_orders)
  end

  def test_get_work_orders_with_status_in_progress
    @manage_workers.assign(@worker, @work_order1)
    @manage_workers.assign(@worker, @work_order2)
    @manage_workers.assign(@worker, @work_order3)

    work_orders = @manage_workers.get_work_orders_with_status(@worker, 'in progress')

    assert_equal([@work_order2], work_orders)
  end
end
