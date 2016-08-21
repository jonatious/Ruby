class ManageWorkers 
  def assign(worker, work_order)
    worker.work_orders << work_order
    worker.save
  end
  
  def get_not_completed_work_orders(worker)
    worker.work_orders.where.not(:status => 'completed')
  end
  
  def get_work_orders_with_status(worker, status)
    worker.work_orders.where(:status => status)
  end
end