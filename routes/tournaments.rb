# encoding: UTF-8
require 'json'

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
end

