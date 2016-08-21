class WorkOrder < ActiveRecord::Base
  validates_presence_of :work_details, :creation_date, :status_update_date
  belongs_to :worker
  validates_inclusion_of :status, in: %w(created review in\ progress completed)
end