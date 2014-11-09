# encoding: UTF-8
require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require 'sidekiq'

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :username => "root",
  :password => "",
  :database => "pgn_eval"
)

require './models/init'
require './helpers/init'
require './routes/init'
