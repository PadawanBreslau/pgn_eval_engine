# encoding: UTF-8
require 'open-uri'
require 'byzantion_chess'
require 'pgn_parser'
require 'treetop'
require 'digest'
require 'pry'
require 'philio_uci/engine'
require 'philio_uci/data_parser'

class EngineHelper

  def self.download_file(remote_url, tournament_id)
    filename = Time.now.strftime("%Y%m%d%H%M%S")
    FileUtils.mkdir_p "./pgn/#{tournament_id}/"
    full_filename = "./pgn/#{tournament_id}/#{filename}.pgn"
    File.open(full_filename, "wb") do |saved_file|
      open(remote_url, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
    full_filename
  end

  def self.byz_parse_file(pgn_file, tournament_id)
    begin
      pgn_content = PgnFileContent.new(File.read(pgn_file), ST_LOG)
      parsed_content = pgn_content.parse_games
      ST_LOG.info "Parsed games. Games count: #{parsed_content.size}"
      parsed_content.each do |one_game|
        raise "Should be a ByzantionChess::Game class" unless one_game.kind_of?(Game)
        board = ByzantionChess::Board.new
        header = one_game.header
        next if header["White"].nil? || header["Black"].nil? || header["Round"].nil?
        moves = one_game.moves
        fen_after = moves["0"].map do |move|
          move.execute(board)
          board.writeFEN
        end
        #ST_LOG.info "Received new moves: #{moves}"
        game = find_by_game_uuid(header, tournament_id)
        new_moves = add_new_moves(game, moves, fen_after)
        new_moves.each do |move|
          #GameAnalysis.perform_async(move.to_s)
          GameAnalysis.analyse_synch(move.fen_after)
        end
      end
    rescue StandardError => e
      ER_LOG.info "Problem with importing games from PGN file"
      ER_LOG.error e.message
      raise e
    end
  end

  def self.new_moves?(filename)
    return true   # TMP - remove
    path = File.dirname(filename)
    Dir.glob(path) do |item|
      return false if FileUtils.compare_file(item, filename) && item != new_filename
    end
    true
  end

  def self.find_by_game_uuid(header, tournament_id)
    game_uuid = generate_header_uuid(header)
    ST_LOG.info "Looking for game with uuid: #{game_uuid}"
    game = GameAnalysis.find_by_uuid(game_uuid)
    return game if game
    add_new_game(header, game_uuid, tournament_id) if game.nil? || game.tournament.id != tournament_id
  end

  def self.generate_header_uuid(header)
    white_hash = Digest::MD5.hexdigest header["White"]
    black_hash = Digest::MD5.hexdigest header["Black"]
    round_hash = Digest::MD5.hexdigest header["Round"]
    "#{white_hash}-#{black_hash}-#{round_hash}"
  end

  def self.add_new_moves(game, moves, fen_after)
    current_moves_size = game.moves.size
    previous_move_id = game.moves.last.try(:id)
    new_moves = moves["0"][current_moves_size..-1]
    new_fen_after = fen_after[current_moves_size..-1]
    result = []
    new_moves.each_with_index do |new_move, i|
      start_field, end_field = new_move.to_s.split('-')
      move = Move.create(start_field: start_field, end_field: end_field, game_id: game.id, previous_move_id: previous_move_id, fen_after: new_fen_after[i])
      previous_move_id = move.id
      result << move
    end
    result
  end

  def self.add_new_game(header, game_uuid, tournament_id)
    tournament = Tournament.find_by_id(tournament_id)
    round = header["Round"].split('.').first
    tournament_round = tournament.rounds.select{|r| r.number = round}.first
    create_round(tournament_id, round) if tournament_round.nil?
    GameAnalysis.create!(uuid: game_uuid, round_id: (tournament_round || Round.last).id)
  end

  def self.create_round(tournament_id, number)
    Round.create!(tournament_id: tournament_id, number: number)
  end

  def self.analyse_move(fen, time=5)
    engine = PhilioUCI::Engine.new({:engine_path => './engine/stockfish_x64'})
    engine.send_command "uci"
    engine.send_command("position", "fen", fen)
    engine.send_command "go" , "infinite"
    sleep(time)
    result = engine.send_command "stop"
    return_engine_analysis_as_hash(result)
  end

  def self.return_engine_analysis_as_hash(result)
    evaluations = result.select{|res| res.match('seldepth')}
    evaluation = PhilioUCI::DataParser.parse_eval_string(evaluations.last)
    evaluation[:variation]
  end
end
