class Work < ActiveRecord::Base
  
  validates_presence_of :name
  
  belongs_to :work_status
  belongs_to :worker
  
  before_save :assign_work_status
  
  private
  def assign_work_status
    self.work_status = WorkStatus.find_by_status("Created") if self.work_status == nil
  end
end
