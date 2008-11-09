require "#{File.dirname(__FILE__)}/../superheroes"
require "#{File.dirname(__FILE__)}/fixtures"

describe SuperHeroes::ActionControllerIntegration do

  setup do
    @citizen = User.make_citizen
    @policeman = User.make_policeman
    @demigod = User.make_demigod
    @another_demigod = User.make_demigod

    @class = Class.new
    @class.class_eval do
      include SuperHeroes::ActionControllerIntegration
      def self.before_filter(*args); end
      def assigns(*args); end
    end
  end

  def add_check(&check)
    @class.class_eval(&check)
  end

  it 'binds check as a class method when included' do
    @class.respond_to?(:check).should == true
  end

  describe 'a simple check on a subject' do

    setup do
      add_check { check(:user).can.enforce_the_rule_of_law? }
      @instance = @class.new
      @instance.stub!(:assigns).with(nil).and_return(nil)
    end

    it 'sets up a before filter instance method based on the check' do
      @instance.respond_to?(:check_user_can_enforce_the_rule_of_law?).should == true
    end

    it 'creates a before_filter on the class with the generated method' do
      @class.should_receive(:before_filter).with(:check_user_can_enforce_the_rule_of_law?, {})
      add_check { check(:user).can.enforce_the_rule_of_law? } # damn mocks
    end

    it 'does nothing if the filter is successful' do
      @instance.should_receive(:assigns).any_number_of_times.with(:user).and_return(@policeman)
      @instance.should_not_receive(:cannot_perform_ability)
      @instance.check_user_can_enforce_the_rule_of_law?
    end

    it 'calls cannot_perform_ability if the filter is unsuccessful' do
      @instance.should_receive(:assigns).any_number_of_times.with(:user).and_return(@citizen)
      @instance.should_receive(:cannot_perform_ability).with(@citizen, :enforce_the_rule_of_law?, nil)
      @instance.check_user_can_enforce_the_rule_of_law?
    end

  end

  describe 'a check that requires a target' do

    setup do
      add_check { check(:user).can.get_into_a_lightning_fight?(:another_user) }
      @instance = @class.new
    end

    it 'sets up a before filter instance method based on the check' do
      @instance.respond_to?(:check_user_can_get_into_a_lightning_fight?).should == true
    end

    it 'creates a before_filter on the class with the generated method' do
      @class.should_receive(:before_filter).with(:check_user_can_get_into_a_lightning_fight?, {})
      add_check { check(:user).can.get_into_a_lightning_fight?(:another_user) } # damn mocks
    end

    it 'does nothing if the filter is successful' do
      @instance.should_receive(:assigns).any_number_of_times.with(:user).and_return(@demigod)
      @instance.should_receive(:assigns).any_number_of_times.with(:another_user).and_return(@another_demigod)
      @instance.should_not_receive(:cannot_perform_ability)
      @instance.check_user_can_get_into_a_lightning_fight?
    end

    it 'calls cannot_perform_ability if the filter is unsuccessful' do
      @instance.should_receive(:assigns).any_number_of_times.with(:user).and_return(@demigod)
      @instance.should_receive(:assigns).any_number_of_times.with(:another_user).and_return(@demigod)
      @instance.should_receive(:cannot_perform_ability).with(@demigod, :get_into_a_lightning_fight?, @demigod)
      @instance.check_user_can_get_into_a_lightning_fight?
    end

  end

  describe 'a check that passes in filter opts' do

    it 'passes through the filter options' do
      @class.should_receive(:before_filter).with(:check_user_can_enforce_the_rule_of_law?, {:only => :enforce_the_law!})
      add_check { check(:user).can.enforce_the_rule_of_law?(:only => :enforce_the_law!) }
    end

  end

  describe 'a check that requires a target and passes in filter opts'

  it 'handles method_mising more proper, i.e. look into abilities then re-raise if there is a miss' # same issue with workflow right here, so there is a pattern!

end
