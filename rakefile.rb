task :default => :spec

task :spec do
  puts `spec --color spec/*_spec.rb`
end
