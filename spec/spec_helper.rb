ENV['RACK_ENV'] = 'test'
require('rspec')
require('pg')
require('sinatra/activerecord')
require('./lib/recipe')
require('./lib/tag')

RSpec.configure do |config|
  config.before(:each) do

    Recipe.destroy_all

    Tag.destroy_all
  end
end
