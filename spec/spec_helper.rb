require "#{File.dirname(__FILE__)}/../lib/oa-globocom"
require 'webmock/rspec'
require 'rack/mock'
require 'timecop'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|  
  config.mock_with :rspec
  config.filter_run :wip => true
  config.run_all_when_everything_filtered = true
  
  config.before(:suite) do
    WebMock.disable_net_connect!(:allow_localhost => true)
  end
end

def stub_requests
  stub_request(:put, "http://isp-authenticator.dev.globoi.com:8280/ws/rest/autorizacao").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/autorizacao.xml"))
  stub_request(:get, "http://isp-authenticator.dev.globoi.com:8280/cadunii/ws/resources/pessoa/21737810").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/pessoa.xml"))
end

def stub_fail_requests
  stub_request(:put, "http://isp-authenticator.dev.globoi.com:8280/ws/rest/autorizacao").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/autorizacao_fail.xml"))
  stub_request(:get, "http://isp-authenticator.dev.globoi.com:8280/cadunii/ws/resources/pessoa/21737810").to_return(:body => File.new("#{File.dirname(__FILE__)}/support/fixtures/pessoa.xml"))
end
