ENV['RACK_ENV'] = 'test'

require_relative './../main'
require 'spec_helper'

describe 'Pgn Eval Enging' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'creating new tournament' do
    it "says hello" do
       post '/'
    end
  end
end
