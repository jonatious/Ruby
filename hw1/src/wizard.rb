class Wizard
  def initialize()
	@spells = Hash.new
  end
  
  def learn(spell, &block)
	@spells[spell] = lambda &block
  end

  def method_missing(name, *args)
	if @spells.key?(name.to_s)
		@spells[name.to_s].call(*args)
	else
		raise "Unknown Spell"
	end
  end
  
end