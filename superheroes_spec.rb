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

  can :do_police_things do
    police? or demigod?
  end

  can :do_demigod_things do
    demigod?
  end

end

describe SuperHeroes do
  
  before do
    @user = User.new(false, false)
    @police = User.new(true, false)
    @demigod = User.new(false, true)
  end

  it 'says user cannot do police things' do
    @user.can?(:do_police_things).should == false
  end

  it 'says user cannot do demigod things' do
    @user.can?(:do_demigod_things).should == false
  end

  it 'says police can do police things' do
    @police.can?(:do_police_things).should == true 
  end

  it 'says police cannot do demigod things' do
    @police.can?(:do_demigod_things).should == false
  end
  
  it 'says demigod can do police things' do
    @demigod.can?(:do_police_things).should == true
  end
  
  it 'says demigod can to demigod things' do
    @demigod.can?(:do_demigod_things).should == true
  end

  it 'raises exception when unknown ability is asked for' do
    lambda { @user.can?(:do_backflips) }.should raise_error(SuperHeroes::UnknownAbility)
  end
  
end
