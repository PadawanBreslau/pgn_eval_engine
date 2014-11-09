require File.dirname(__FILE__) + "/pgn_eval_server"
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

run Sidekiq::Web
run Sinatra::Application

#PgnEvalServer::Evaluator.run!
