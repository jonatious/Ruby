class Worker < ActiveRecord::Base
  
  validates_uniqueness_of :first_name, :scope => :last_name, :message => 'and Last name have already been taken'
  validates_presence_of :first_name, :last_name
  
  has_many :works
  
end
