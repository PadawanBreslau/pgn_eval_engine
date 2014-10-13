require 'sinatra'

module PgnEvalServer
  class Evaluator < Sinatra::Base

    get '/check' do
      "Up!"
    end

    get 'start_tournament_broadcast/:tournament_id' do
    end

    get 'stop_tournament_broadcast/:tournament_id' do
    end

    get 'get_all_rounds/:tournament_id' do
    end

    get 'get_all_games/:tournament_id' do
    end

    get 'get_all_round_games/:round_id' do
    end

    get 'get_moves/:game_id' do
    end

    get 'get_variations/:move_id' do
    end

    get 'get_eval/:move_id' do
    end
  end
end
