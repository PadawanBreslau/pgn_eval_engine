# encoding: UTF-8

get '/moves/:game_id' do
  begin
    game = Game.find(params['game_id'])
    [200, game.moves.map(&:id)]
  rescue
    [404, "No game found"]
  end

end

get '/moves/:move_id/analyse' do
  move = Move.find_by_id(params['move_id'])
  EngineHelper.analyse_move(move.fen_after) if move
end
