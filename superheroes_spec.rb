require 'superheroes'

class User

  def initialize(police = false, demigod = false)
    @police, @demigod = police, demigod
  end

  def police?
    @police
  end

  def demigod?
    @demigod
  end

end

SuperHeroes.pretending_to_be_a User do

  can :enforce_the_rule_of_law do
    police? or demigod?
  end

  can :move_mountains do
    demigod?
  end

end

describe SuperHeroes do
  
  before do
    @citizen = User.new(false, false)
    @policeman = User.new(true, false)
    @demigod = User.new(false, true)
  end

  it 'says user cannot enforce the rule of law' do
    @citizen.can?(:enforce_the_rule_of_law).should == false
  end

  it 'says user cannot move mountains' do
    @citizen.can?(:move_mountains).should == false
  end

  it 'says policeman can enforce the rule of law' do
    @policeman.can?(:enforce_the_rule_of_law).should == true 
  end

  it 'says policeman cannot move mountains' do
    @policeman.can?(:move_mountains).should == false
  end
  
  it 'says demigods can enforce the rule of law' do
    @demigod.can?(:enforce_the_rule_of_law).should == true
  end
  
  it 'says demigods can move mountains' do
    @demigod.can?(:move_mountains).should == true
  end

  it 'raises exception when unknown ability is asked about' do
    lambda { @citizen.can?(:do_backflips) }.should raise_error(SuperHeroes::UnknownAbility)
  end

  it 'can reflect possible abilities for a user' do
    SuperHeroes.possible_abilities_for(User).should == [:enforce_the_rule_of_law, :move_mountains]
  end
  
end
