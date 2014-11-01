# encoding: UTF-8
require 'open-uri'
require 'byzantion_chess'
require 'pgn_parser'
require 'treetop'
require 'digest'
require 'pry'

class EngineHelper

  def self.download_file(remote_url, tournament_id)
    filename = Time.now.strftime("%Y%m%d%H%M%S")
    FileUtils.mkdir_p "./pgn/#{tournament_id}/"
    full_filemane = "./pgn/#{tournament_id}/#{filename}.pgn"
    File.open(full_filemane, "wb") do |saved_file|
      open(remote_url, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
    full_filemane
  end

  def self.byz_parse_file(pgn_file, tournament_id)
    begin
      pgn_content = PgnFileContent.new(File.read(pgn_file), ST_LOG)
      parsed_content = pgn_content.parse_games
      ST_LOG.info "Parsed games. Games count: #{parsed_content.size}"
      parsed_content.each do |one_game|
        raise "Should be a ByzantionChess::Game class" unless one_game.kind_of?(Game)
        header = one_game.header
        next if header["White"].nil? || header["Black"].nil? || header["Round"].nil?
        moves = one_game.moves
        ST_LOG.info "Received new moves: #{moves}"
        game = find_by_game_uuid(header, tournament_id)
        add_new_moves(game, moves)
      end
    rescue StandardError => e
      ER_LOG.info "Problem with importing games from PGN file"
      ER_LOG.error e.message
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
    white_hash = Digest::MD5.hexdigest header["White"]
    black_hash = Digest::MD5.hexdigest header["Black"]
    round_hash = Digest::MD5.hexdigest header["Round"]
    game_uuid = "#{white_hash}-#{black_hash}-#{round_hash}"
    ST_LOG.info "Looking for game with uuid: #{game_uuid}"
    game = GameAnalysis.find_by_uuid(game_uuid)
    add_new_game(header, game_uuid, tournament_id) if game.nil? || game.tournament.id != tournament_id
  end

  def self.add_new_moves(game, moves)
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
end
