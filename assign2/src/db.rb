require 'active_record'

def database_name
  './workersdb'
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => database_name
)
