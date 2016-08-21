class Worker < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  has_many :work_orders
end