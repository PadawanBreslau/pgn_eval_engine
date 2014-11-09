# encoding: UTF-8
require 'sidekiq'

class GameAnalysis < ActiveRecord::Base
  include Sidekiq::Worker
  self.table_name = "games"

  belongs_to :round
  delegate :tournament, to: :round
  has_many :moves, foreign_key: :game_id

  def perform(move)
    ST_LOG.info move
    ST_LOG.info '!!!!'
  end

  def self.analyse_synch(fen)
    EngineHelper.analyse_move(fen)
  end
end
