# encoding: UTF-8

get '/games/:tournament_id' do
  begin
    tournament = Tournament.find(params['tournament_id'].to_i)
    games = tournament.game_analysis
    res = games.map(&:id)
    [200, res.join(',')]
  rescue
    [404, "No tournemant found"]
  end
end

get '/round_games/:round_id' do
  begin
    round = Round.find(params['round_id'].to_i)
    res = round.game_analysis.map(&:id)
    [200, res.join(',')]
  rescue
    [404, "No tournemant found"]
  end

end
