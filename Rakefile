# Rakefile
require "sinatra/activerecord/rake"
require 'rspec/core/rake_task'
require "./pgn_eval_server"

RSpec::Core::RakeTask.new :specs do |task|
task.pattern = Dir['spec/**/*_spec.rb']
end

task :default => ['specs']

task :monitor do
  # optional: Process.daemon (and take care of Process.pid to kill process later on)
  require 'sidekiq/web'
  app = Sidekiq::Web
  app.set :environment, :production
  app.set :bind, '0.0.0.0'
  app.set :port, 9494
  app.run!
end
