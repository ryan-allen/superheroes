module SuperHeroes

  module ActionControllerIntegration

    def self.included(something)
      something.extend(ClassMethods)
    end

    module ClassMethods
      def check(subject)
        FilterGenerator.new(self, subject)
      end
    end

  private

    class FilterGenerator 

      def initialize(controller, subject)
        @controller, @subject, @target, @options = controller, subject, nil, {}
      end

      def can
        @op = :can
        self
      end

      def cannot
        @op = :cannot
        self
      end

      def method_missing(ability, *extra)
        parse_extra_into_target_and_options(*extra)
        filter_name = "check_#{@subject}_#{@op}_#{ability}".to_sym
        subject, op, options, target = @subject, @op, @options, @target
        @controller.class_eval do
          before_filter filter_name, *[options]
          define_method filter_name do
            cannot_perform_ability(instance_variable_get("@#{subject}"), ability, instance_variable_get("@#{target}")) unless instance_variable_get("@#{subject}").send(op).send(ability, *[instance_variable_get("@#{target}")])
          end
        end
      end

    private

      def parse_extra_into_target_and_options(*extra)
        if extra.any?
          if extra.length == 1
            if extra.first.is_a?(Hash)
              @target, @options = nil, extra.first
            else
              @target, @options = extra.first, {}
            end
          elsif extra.length == 2
            @target, @options = *extra
          else
            raise 'i was expecting either 0, 1 or 2 items in extra, but i got: ' + extra.inspect
          end
        end
      end

    end

    # this method is called if the filter determines the ability to not be available to the
    # subject, by default it'll render a 404 and display a blank page, you can override this
    # method in your application controller for further niceness if you so desire
    def cannot_perform_ability(subject, ability, target)
      head(404) 
    end

  end

end
