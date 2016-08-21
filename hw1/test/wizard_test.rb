# HW 1. Due 11:59PM June 11
# You can check in your solution as many times as you like.
# You will not have write access to check in files for this HW after the deadline.

#Feel free to ask for reviews along the way as you work on your homework and assignments.
#Please see the reviews/readme.txt file for details on how to ask for a review.

# Write a Wizard that will learn spells
# You can then ask the wizard to practice some of those spells by calling it.
# What's a better way to explain that some unit tests!   

# uncomment one test at a time and write the minimum code in wizard.rb to make all the uncommented tests pass.

#To run the tests, type rake from the hw1 directory

require './src/Wizard'
require 'minitest/autorun'

class WizardTest < MiniTest::Unit::TestCase
  def setup
    @wiz = Wizard.new
  end

  # def test_canary
  #   assert true
  # end

  def test_teach_one_spell
    got_here = false
    @wiz.learn('telepathy') { puts "I see what you're thinking"; got_here = true}
    
    @wiz.telepathy
    assert(got_here)
  end

  def test_teach_another_spell
    got_here = false
    spell_code = lambda { puts "no more clouds"; got_here = true}
    @wiz.learn('stop_rain', &spell_code)
    
    @wiz.stop_rain
    assert(got_here)
  end

  def test_teach_a_couple_of_spells
    got_here1 = false
    got_here2 = false
    @wiz.learn('get_what_you_want') { |want| puts want; got_here1 = true }
    @wiz.learn('sleep') { puts 'zzzzzzzzzzzz'; got_here2 = true}
    
    @wiz.get_what_you_want("I'll get an 'A'")
    @wiz.sleep
    
    assert(got_here1 && got_here2)
  end

  def test_unknown_spell
    @wiz.learn('rain') { puts '...thundering...' }
    
    assert_raises(RuntimeError, "Unknown Spell") {@wiz.raln }
  end  

  def test_call_a_spell_more_than_once
    count = 0
    
    @wiz.learn('tickle') { puts 'he heee'; count += 1}
    
    @wiz.tickle
    @wiz.tickle
    
    assert_equal(2, count)
  end
  
#new tests  
  def test_relearn_a_spell
   code = 0
   @wiz.learn('program') { code += 1 }
   
   @wiz.program
   
   assert_equal(1, code)
   
   code2 = 0
   @wiz.learn('program') { code2 += 1 }
   @wiz.program
   assert_equal(1, code)
   assert_equal(1, code2)
  end
  
  def test_exception_throwing_spell
   @wiz.learn('blowup') { raise "blowup" }
   
   assert_raises(RuntimeError) { @wiz.blowup }
  end
  
  def test_pass_fewer_params
    @wiz.learn('want') { |want| puts want }

    ex = assert_raises(ArgumentError) { @wiz.want }
    assert_equal 'wrong number of arguments (0 for 1)', ex.message
  end

  def test_more_params_than_needed
    @wiz.learn('want') { |want| puts want }
    
    ex = assert_raises(ArgumentError) { @wiz.want('a', '1') }
    assert_equal 'wrong number of arguments (2 for 1)', ex.message
  end

  def test_param_when_none_expected
    @wiz.learn('rain') { puts 'drizzle' }
    
    ex = assert_raises(ArgumentError) { @wiz.rain('heavy') }
    assert_equal 'wrong number of arguments (1 for 0)', ex.message
  end
end
