# encoding: UTF-8

class EngineHelper

  def self.download_file(remote_url, tournament_id)
    filename = Time.now.strftime("%Y%m%d%H%M%S")
    FileUtils.mkdir_p "./pgn/#{tournament_id}/"
    File.open("./pgn/#{tournament_id}/#{filename}.pgn", "wb") do |saved_file|
      # the following "open" is provided by open-uri
      open(remote_url, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end

  def self.byz_parse_file(file)
  end

  def self.update_tournament_games(tournament, parsed_file)
  end

  def self.analyse_new_moves(tournament)
  end

end
