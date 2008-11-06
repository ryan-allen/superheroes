task :default => :spec

task :spec do
  puts `spec --color superheroes_spec.rb`
end
