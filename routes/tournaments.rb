# encoding: UTF-8
require 'json'
require_relative '../helpers/engine_helper'

# list of all tournaments
get '/tournaments' do
  @tournaments = Tournament.all
  @tournaments.map do |t|
    @on = " ONLINE" unless t.is_finished
    t.id.to_s + '.' + t.url + @on + '\n'
  end
end

## Forces to download current pgn file
get '/tournaments/:tournament_id/force_update' do
  begin
    @tournament = Tournament.find(params['tournament_id'])
    file = EngineHelper.download_file(@tournament.url, @tournament.id)
    if EngineHelper.new_moves?(file)
      EngineHelper.byz_parse_file(file, @tournament.id)
    end
    [200, "OK"]
  rescue StandardError => e
    ER_LOG.error e.backtrace
    [404, e.message]
  end
end

# Adds a new tournament to be analysed
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

## Updates is_finished attribute to true
get '/tournaments/:tournament_id/start_broadcast' do
  begin
    @tournament = Tournament.find(params['tournament_id'])
    @tournament.update_attribute(:is_finished, false)
    [200, "OK"]
  rescue
    [404, "Tournament not found"]
  end
end

## Updates is_finished attribute to false
get '/tournaments/:tournament_id/stop_broadcast' do
  begin
    @tournament = Tournament.find(params['tournament_id'])
    @tournament.update_attribute(:is_finished, true)
    [200, "OK"]
  rescue
    [404, "Tournament not found"]
  end
end

# Returns all round of one tournament
get '/tournament/:tournament_id/rounds' do
  begin
    @tournament = Tournament.find(params['tournament_id'])
    [200, @tournament.rounds.map(&:id).join(',')]
  rescue
    [404, "Tournament not found"]
  end
end

