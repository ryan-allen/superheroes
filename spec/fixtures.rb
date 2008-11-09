class User

  class << self

    def make_citizen
      new false, false
    end

    def make_policeman
      new true, false
    end

    def make_demigod
      new false, true
    end
     
    private :new

  end

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

  special_ability :enforce_the_rule_of_law do
    police? or demigod?
  end

  special_ability :move_mountains do
    demigod?
  end

  special_ability :get_into_a_lightning_fight do |other_user|
    demigod? and other_user.demigod? and self != other_user
  end

end
