class ChessLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "[#{timestamp.to_formatted_s(:db)}]  [#{severity}]  #{msg}\n"
  end
end

ST_LOG = ChessLogger.new(File.open("./log/standard_info.log", 'a'))
ER_LOG = ChessLogger.new(File.open("./log/standard_error.log", 'a'))
