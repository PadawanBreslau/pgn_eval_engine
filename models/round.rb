# encoding: UTF-8

class Round < ActiveRecord::Base

belongs_to :tournament
has_many :game_analysis
end
