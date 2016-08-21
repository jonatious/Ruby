class WorkStatus < ActiveRecord::Base

  validates :status, :presence => true, :uniqueness => true, :inclusion => { in: %w(Created Assigned Completed)}
  
end
