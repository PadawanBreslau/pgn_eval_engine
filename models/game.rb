# encoding: UTF-8

class GameAnalysis < ActiveRecord::Base
  self.table_name = "games"

  belongs_to :rounds
  has_many :moves
end
