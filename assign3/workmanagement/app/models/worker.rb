class Worker < ActiveRecord::Base
  validates_uniqueness_of :first_name, :scope => :last_name
  validates_presence_of :first_name
  
  has_many :works
end
