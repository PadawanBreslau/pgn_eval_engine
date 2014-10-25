# Rakefile
require "sinatra/activerecord/rake"
require 'rspec/core/rake_task'
require "./main"

RSpec::Core::RakeTask.new :specs do |task|
task.pattern = Dir['spec/**/*_spec.rb']
end

task :default => ['specs']
