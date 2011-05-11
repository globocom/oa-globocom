require "#{File.dirname(__FILE__)}/../lib/oa-cadun"
require 'fakeweb'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before :suite do
    FakeWeb.allow_net_connect = false
  end
  
  config.before :each do
    FakeWeb.clean_registry
  end
  
  config.mock_with :rr
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

def app
  lambda{|env| [200, {}, ['Hello']]}
end