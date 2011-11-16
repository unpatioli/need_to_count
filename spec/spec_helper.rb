require "rubygems"
require "bundler/setup"
Bundler.require :development

require 'need_to_count'

# ================
# = Requirements =
# ================
# Db schema
require File.dirname(__FILE__) + '/support/schema.rb'

# FactoryGirl factories
Dir[File.expand_path('../support/{factories}/*.rb', __FILE__)].each do |f|
  require f
end

# Models
# Todo: model loading regardless to order
load File.dirname(__FILE__) + '/support/models/recipe.rb'
load File.dirname(__FILE__) + '/support/models/cuisine.rb'

# =================
# = Configuration =
# =================
RSpec.configure do |c|
  c.before(:suite) do
    # migrate
    Schema.create
  end
  
  # c.mock_with :rspec
  
  # Factory Girl shortcuts
  c.include FactoryGirl::Syntax::Methods
end