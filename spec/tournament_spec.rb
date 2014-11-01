ENV['RACK_ENV'] = 'test'

require_relative './../pgn_eval_server'
require 'spec_helper'

describe 'Pgn Eval Enging' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'creating new tournament' do
    it 'should create new tournament' do
      header = {'Content-Type' => 'application/json'}
      body = { url: 'http://some.url/trans.pgn' }.to_json
      DatabaseCleaner.cleaning do
        post '/create_new_tournament/', body, header
      end
      last_response.status.should eq 201
    end

    it 'should not create tournement without url' do
      header = {'Content-Type' => 'application/json'}
      body = { }.to_json
      post '/create_new_tournament/', body, header
      last_response.status.should eq 422
    end

    it 'should not create new tournament when url taken' do
      header = {'Content-Type' => 'application/json'}
      body = { url: 'http://some.url/trans.pgn' }.to_json
      DatabaseCleaner.cleaning do
        post '/create_new_tournament/', body, header
        post '/create_new_tournament/', body, header
      end
      last_response.status.should eq 422
    end
  end


  context 'start and end tournament broadcast' do
    DatabaseCleaner.cleaning do
      before do
        Tournament.delete_all
        header = {'Content-Type' => 'application/json'}
        body = { url: 'http://some.url/trans2.pgn' }.to_json
        post '/create_new_tournament/', body, header
      end

      it 'should start and end broadcast' do
        @tournament = Tournament.last
        @tournament.should_not be_nil
        @tournament.is_finished.should be_true
        get "/start_tournament_broadcast/#{@tournament.id}"
        last_response.status.should eq 200
        @tournament.reload
        @tournament.is_finished.should be_false
        get "/stop_tournament_broadcast/#{@tournament.id}"
        last_response.status.should eq 200
        @tournament.reload
        @tournament.is_finished.should be_true
      end
    end
  end
end
