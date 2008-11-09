require "#{File.dirname(__FILE__)}/3rd-party/eigenclass_instance_exec"

module SuperHeroes

  class << self

    @@vault = {}

    def pretending_to_be_a(target, &powers)
      @@vault[target] = {}
      Assembler.new(target, @@vault[target], &powers).evaluate!
    end

    alias :pretending_to_be_an :pretending_to_be_a # grammar is important!

    def possible_abilities_for(target)
      @@vault[target].keys
    end

    def evaluate_ability(object, ability, *extra)
      if @@vault[object.class] and @@vault[object.class][ability]
        object.instance_exec(*extra, &@@vault[object.class][ability])
      else
        raise UnknownAbility.new("no ability #{ability.inspect} found for #{object.class.inspect}")
      end
    end

  end

private

  class UnknownAbility < RuntimeError; end

  class HigherOrderProxy

    def initialize(object, invert = false)
      @object, @invert = object, invert
    end

    def method_missing(ability, *extra)
      evaluation = SuperHeroes.evaluate_ability(@object, ability.to_s[0..-2].to_sym, *extra)
      @invert ? !evaluation : evaluation
    end

  end
  
  class Assembler

    def initialize(target, vault, &powers)
      @target, @vault, @powers = target, vault, powers
      @target.class_eval do
        def can?(ability, *extra)
          SuperHeroes.evaluate_ability(self, ability, *extra)
        end

        def cannot?(ability, *extra)
          !SuperHeroes.evaluate_ability(self, ability, *extra)
        end

        def can
          HigherOrderProxy.new(self) 
        end

        def cannot
          HigherOrderProxy.new(self, true)
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
