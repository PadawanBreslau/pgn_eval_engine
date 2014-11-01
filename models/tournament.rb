# encoding: UTF-8

class Tournament < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true
  has_many :rounds
  has_many :game_analysis, through: :rounds
end
