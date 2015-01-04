ENV['RACK_ENV'] = 'test'

require_relative './../pgn_eval_server'
require 'spec_helper'

describe 'GameAnalysis' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  DatabaseCleaner.cleaning do
    context 'tournament_games' do
      before do
        Tournament.delete_all
        Round.delete_all
        GameAnalysis.delete_all
        Tournament.create(url: 'aaa.pgn')
        @tournament_id = Tournament.last.id
        (1..2).each do |i|
          Round.create!(tournament_id: @tournament_id, number: i)
        end
        GameAnalysis.create!(round_id: Round.first.id)
        GameAnalysis.create!(round_id: Round.first.id)
        GameAnalysis.create!(round_id: Round.last.id)
        @game_ids = GameAnalysis.all.map(&:id)
        @round_id = Round.first.id
        @round_game_ids = Round.first.game_analysis.map(&:id)
      end

      it 'should list all games of tournament' do
        get "/tournaments/#{@tournament_id}/games"
        last_response.status.should eq 200
        last_response.body.should eq @game_ids.join(',')
      end

      it 'should return 404 if no tournament' do
        get "/games/0"
        last_response.status.should eq 404
      end

      it 'should list all games of tournament' do
        get "/rounds/#{@round_id}/games"
        last_response.status.should eq 200
        last_response.body.should eq @round_game_ids.join(',')
      end
    end
  end
end
