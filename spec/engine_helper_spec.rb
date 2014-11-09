ENV['RACK_ENV'] = 'test'

require_relative './../pgn_eval_server'
require 'spec_helper'

describe 'Engine Helper' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  DatabaseCleaner.cleaning do

    context 'engine helper methods' do
      before do
        Tournament.delete_all
        Round.delete_all
        GameAnalysis.delete_all
        @tournament = Tournament.create!(url: 'http://engine_helper.org')
        @round = Round.create!(tournament_id: Tournament.last.id)
        white_player = SecureRandom.hex(4)
        black_player = SecureRandom.hex(4)
        round = "1"
        @header = {"White" => white_player, "Black" => black_player, "Round" => round}
        @uuid = EngineHelper.generate_header_uuid(@header)
      end

      it 'should not raise error if game is not available' do
        expect(EngineHelper.find_by_game_uuid(@header, @tournament.id)).to eq GameAnalysis.last
      end

      it 'should find game by uuid' do
        GameAnalysis.create(round_id: Round.last.id, uuid: @uuid)
        expect(EngineHelper.generate_header_uuid(@header)).to eql @uuid
        expect(EngineHelper.find_by_game_uuid(@header, @tournament.id)).to eq GameAnalysis.last
      end
    end
  end
end
