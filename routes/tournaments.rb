# encoding: UTF-8
require 'json'
require_relative '../helpers/engine_helper'

get '/tournaments' do
  @tournaments = Tournament.all
  @tournaments.map do |t|
    @on = " ONLINE" unless t.is_finished
    t.id.to_s + '.' + t.url + @on + '\n'
  end
end

get '/tournaments/:tournament_id/force_update' do
  begin
    @tournament = Tournament.find(params['tournament_id'])
    file = EngineHelper.download_file(@tournament.url, @tournament.id)
    if EngineHelper.new_moves?(file)
      EngineHelper.byz_parse_file(file, @tournament.id)
    end
    [200, "OK"]
  rescue StandardError => e
    [404, e.message]
  end
end

post '/create_new_tournament/' do
  begin
    data = JSON.parse(request.body.read)
    Tournament.create!(url: data['url'], is_finished: true)
    [201, Tournament.last.id.to_s]
  rescue ActiveRecord::RecordInvalid => e
    [422, "Tournament not saved - #{e.message}"]
  rescue StandardError => e
    [409, "Tournament not created - #{e.message}"]
  end
end

get '/start_tournament_broadcast/:tournament_id' do
  begin
    @tournament = Tournament.find(params['tournament_id'])
    @tournament.update_attribute(:is_finished, false)
    [200, "OK"]
  rescue
    [404, "Tournament not found"]
  end
end

get '/stop_tournament_broadcast/:tournament_id' do
  begin
    @tournament = Tournament.find(params['tournament_id'])
    @tournament.update_attribute(:is_finished, true)
    [200, "OK"]
  rescue
    [404, "Tournament not found"]
  end
end

get '/rounds/:tournament_id' do
  begin
    @tournament = Tournament.find(params['tournament_id'])
    [200, @tournament.rounds.map(&:id).join(',')]
  rescue
    [404, "Tournament not found"]
  end
end

