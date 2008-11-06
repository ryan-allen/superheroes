config_file_path = "#{Rails.root}/config/initializers/superheroes.rb"
if File.exist?(config_file_path)
  puts "superheroes.rb exists in config/initializers so i ain't doin' nuffin!"
else
  puts "creating placeholder superheroes.rb in config/initializers..."
  open(config_file_path, 'w') { |f| f.write "# placeholder configuration for SuperHeroes plugin" }
  puts "done!"
end
