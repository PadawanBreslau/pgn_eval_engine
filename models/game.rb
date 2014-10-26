# encoding: UTF-8

class Game < ActiveRecord::Base
  belongs_to :rounds
  has_many :moves
end
