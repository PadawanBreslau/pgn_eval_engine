# encoding: UTF-8

get '/moves/:game_id' do
  begin
    game = Game.find(params['game_id'])
    [200, game.moves.map(&:id)]
  rescue
    [404, "No game found"]
  end
end
