require 'minitest/autorun'
require './src/db'
require './src/worker'

class WorkerTest < MiniTest::Unit::TestCase
  def test_canary
    assert true
  end      
  
  def setup
    @worker = Worker.new(first_name: 'James', last_name: 'Bond')
  end                                                        
  
  def test_worker_is_valid
    assert @worker.valid?
  end
  
  def test_first_name_required
    @worker.first_name = ''
    assert !@worker.valid?
    assert_equal ["First name can't be blank"], @worker.errors.full_messages
  end

  def test_last_name_required
    @worker.last_name = ''
    assert !@worker.valid?
    assert_equal ["Last name can't be blank"], @worker.errors.full_messages
  end 
end
