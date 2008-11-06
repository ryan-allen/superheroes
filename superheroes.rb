module SuperHeroes

  class << self

    @@vault = {}

    def pretending_to_be_a(target, &powers)
      @@vault[target] = {}
      Assembler.new(target, @@vault[target], &powers).evaluate!
    end

    def possible_abilities_for(target)
      @@vault[target].keys
    end

    def evaluate_ability(object, ability)
      if @@vault[object.class] and @@vault[object.class][ability]
        object.instance_eval(&@@vault[object.class][ability])
      else
        raise UnknownAbility.new("no ability #{ability.inspect} found for #{object.class.inspect}")
      end
    end

  end

private

  class UnknownAbility < RuntimeError; end
  
  class Assembler

    def initialize(target, vault, &powers)
      @target, @vault, @powers = target, vault, powers
      @target.class_eval do
        def can?(ability)
          SuperHeroes.evaluate_ability(self, ability)
        end
      end
    end

    def evaluate!
      instance_eval(&@powers)
    end

  private

    def can(ability, &evaluator)
      @vault[ability] = evaluator
    end

  end

end
