# encoding: UTF-8

get '/games/:tournament_id' do
  begin
    tournament = Tournament.find(params['tournament_id'].to_i)
    games = tournament.games
    res = games.map(&:id)
    [200, res.join(',')]
  rescue
    [404, "No tournemant found"]
  end
end

get '/round_games/:round_id' do
  begin
    round = Round.find(params['round_id'].to_i)
    res = round.games.map(&:id)
    [200, res.join(',')]
  rescue
    [404, "No tournemant found"]
  end

end
