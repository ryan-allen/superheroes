config_file_path = "#{Rails.root}/config/initializers/superheroes.rb"
if File.exist?(config_file_path)
  puts "superheroes.rb exists in config/initializers so i ain't doin' nuffin!"
else
  puts "creating placeholder superheroes.rb in config/initializers..."
  open(config_file_path, 'w') do |f| 
    f.write <<-ruby
#
# define your SuperHeroes' special_abilities here, e.g.
#
# SuperHeroes.pretending_to_be_a User do
# 
#   special_ability :can_fly do
#     name == 'Superman'
#   end 
#
#   special_ability :can_defeat do |hero|
#     hero.name == 'Superman' # nobody can beat Superman!
#   end 
#
# end
#

# this file doesn't play well with dependency reloading, so we're
# using dispatcher's to_prepare facility to enforce reloading of
# this file on each request (but only in development mode)
if ENV['RAILS_ENV'] == 'development'
  require 'dispatcher'
  Dispatcher.to_prepare :reload_superheroes_configuration do
    load __FILE__
  end
end
    ruby
  end
  puts "done!"
end
