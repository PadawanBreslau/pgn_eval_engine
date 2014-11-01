ENV['RACK_ENV'] = 'test'

require_relative './../pgn_eval_server'
require 'spec_helper'

describe 'Game' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'tournament_gates' do
    before do
      Tournament.delete_all
      Round.delete_all
      Game.delete_all
      Tournament.create(url: 'aaa.pgn')
      @tournament_id = Tournament.last.id
      (1..2).each do |i|
        Round.create!(tournament_id: @tournament_id, number: i)
      end
      Game.create!(round_id: Round.first.id)
      Game.create!(round_id: Round.first.id)
      Game.create!(round_id: Round.last.id)
      @game_ids = Game.all.map(&:id)
      @round_id = Round.first.id
      @round_game_ids = Round.first.games.map(&:id)
    end

    it 'should list all games of tournament' do
      get "/games/#{@tournament_id}"
      last_response.status.should eq 200
      last_response.body.should eq @game_ids.join(',')
    end

    it 'should return 404 if no tournament' do
      get "/games/0"
      last_response.status.should eq 404
    end

    it 'should list all games of tournament' do
      get "/round_games/#{@round_id}"
      last_response.status.should eq 200
      last_response.body.should eq @round_game_ids.join(',')
    end
  end
end
