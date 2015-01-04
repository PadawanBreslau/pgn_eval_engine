# encoding: UTF-8

# Gets all moves from one game
get '/games/:game_id/moves' do
  begin
    game = Game.find(params['game_id'])
    [200, game.moves.map(&:id)]
  rescue
    [404, "No game found"]
  end

end

## Turns on analysis for a move
get '/moves/:move_id/analyse' do
  begin
  move = Move.find_by_id(params['move_id'])
  if move
    analysis = EngineHelper.analyse_move(move.fen_after)
    [201, analysis]
  else
    [404, "Unable to find  move"]
  end
  rescue StanderdError => e
    [400, e.message]
  end
end
