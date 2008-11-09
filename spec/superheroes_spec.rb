require "#{File.dirname(__FILE__)}/../superheroes"
require "#{File.dirname(__FILE__)}/fixtures"

describe SuperHeroes do
  
  before do
    @citizen = User.make_citizen
    @policeman = User.make_policeman
    @demigod = User.make_demigod
    @another_demigod = User.make_demigod
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

  it 'says citizen cannot fight a demigod with lightning' do
    @citizen.can?(:get_into_a_lightning_fight, @demigod).should == false 
  end

  it 'says demigod can fight another demigod with lightning' do
    @demigod.can?(:get_into_a_lightning_fight, @another_demigod).should == true
  end

  it 'says demigod cannot fight themselves with lightning' do
    @demigod.can?(:get_into_a_lightning_fight, @demigod).should == false
  end

  it 'raises exception when unknown ability is asked about' do
    lambda { @citizen.can?(:do_backflips) }.should raise_error(SuperHeroes::UnknownAbility)
  end

  it 'can reflect possible abilities for a user' do
    SuperHeroes.possible_abilities_for(User).should include(:enforce_the_rule_of_law)
    SuperHeroes.possible_abilities_for(User).should include(:move_mountains)
    SuperHeroes.possible_abilities_for(User).should include(:get_into_a_lightning_fight)
  end

  it 'believes grammar is liek supar important lol' do
    SuperHeroes.respond_to?(:pretending_to_be_an).should == true
  end

  it 'has a cannot method that returns the opposite of can (without targets)' do
    @citizen.cannot?(:enforce_the_rule_of_law).should == true
  end

  it 'has a cannot method that returns the opposite of can (with targets)' do
    @citizen.cannot?(:get_into_a_lightning_fight, @demigod).should == true
  end

  it 'supports higher order syntax without targets' do
    @citizen.can.enforce_the_rule_of_law?.should == false
  end

  it 'supports higher order syntax without targets' do
    @demigod.can.get_into_a_lightning_fight?(@another_demigod).should == true 
  end

  it 'does higher order cannot without targets' do
    @citizen.cannot.enforce_the_rule_of_law?.should == true 
  end

  it 'does higher order cannot with targets' do
    @demigod.cannot.get_into_a_lightning_fight?(@another_demigod).should == false 
  end

end
