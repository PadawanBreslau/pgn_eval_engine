# encoding: UTF-8

#Return all games of the tournament
get '/tournaments/:tournament_id/games' do
  begin
    tournament = Tournament.find(params['tournament_id'].to_i)
    games = tournament.game_analysis
    res = games.map(&:id)
    [200, res.join(',')]
  rescue
    [404, "No tournemant found"]
  end
end

#Return all games of one round
get '/rounds/:round_id/games' do
  begin
    round = Round.find(params['round_id'].to_i)
    res = round.game_analysis.map(&:id)
    [200, res.join(',')]
  rescue
    [404, "No tournemant found"]
  end

end
