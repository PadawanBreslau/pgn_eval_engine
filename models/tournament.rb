# encoding: UTF-8

class Tournament < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true
end
