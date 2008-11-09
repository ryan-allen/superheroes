require "#{File.dirname(__FILE__)}/superheroes"
require "#{File.dirname(__FILE__)}/lib/action_controller_integration"

class ActionController::Base
  include SuperHeroes::ActionControllerIntegration
end
