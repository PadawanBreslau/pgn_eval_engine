require 'rspec'
require 'rack/test'
require 'database_cleaner'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
