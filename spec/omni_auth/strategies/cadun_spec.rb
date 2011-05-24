# encoding: utf-8
require 'spec_helper'

describe OmniAuth::Strategies::Cadun do

  let(:app) { lambda { |env| [200, {}, ['Hello']] } }
  let(:strategy) { OmniAuth::Strategies::Cadun.new(app, :service_id => 1, :config => File.join(File.dirname(__FILE__), "..", "..", "support", "fixtures", "config.yml")) }
  
  describe "#request_phase" do
    context "when it has a referer" do
      before do
        strategy.call!(Rack::MockRequest.env_for("http://test.localhost/auth/cadun", "rack.session" => {}, "HTTP_HOST" => "test.localhost"))

        @status, @headers, @body = strategy.request_phase
      end

      describe "status" do
        subject { @status }
        specify { should == 302 }
      end

      describe "headers" do
        subject { @headers }
        specify { should include("Location" => "https://login.dev.globoi.com/login/1?url=http%3A%2F%2Ftest.localhost%2Fauth%2Fcadun%2Fcallback") }
      end
    end
    
    context "when it has a referer and a different port" do
      before do
        strategy.call!(Rack::MockRequest.env_for("http://test.localhost:8080/auth/cadun", "rack.session" => {}, "HTTP_HOST" => "test.localhost", "SERVER_PORT" => "8080"))

        @status, @headers, @body = strategy.request_phase
      end

      describe "status" do
        subject { @status }
        specify { should == 302 }
      end

      describe "headers" do
        subject { @headers }
        specify { should include("Location" => "https://login.dev.globoi.com/login/1?url=http%3A%2F%2Ftest.localhost%3A8080%2Fauth%2Fcadun%2Fcallback") }
      end
    end
  end
  
  describe "#auth_hash" do
    before do
      stub_requests
      strategy.call!(Rack::MockRequest.env_for("http://localhost?GLBID=GLBID&url=/go_back", "rack.session" => {}))
    end
    
    subject { strategy.auth_hash[:user_info] }
    
    specify { should include(:GLBID => "GLBID") }
    specify { should include(:id => "21737810") }
    specify { should include(:email => "fab1@spam.la") }
    specify { should include(:status => "ATIVO") }
    specify { should include(:nickname => "fabricio_fab1") }
    specify { should include(:name => "Fabricio Rodrigo Lopes") }
    specify { should include(:address => "Rua Uruguai, 59") }
    specify { should include(:suburb => "Andaraí") }
    specify { should include(:city => "Rio de Janeiro") }
    specify { should include(:state => "RJ") }
    specify { should include(:country => "Brasil") }
    specify { should include(:gender => "MASCULINO") }
    specify { should include(:birthday => "22/02/1983") }
    specify { should include(:mobile => "21 99999999") }
    specify { should include(:phone => "21 22881060") }
    specify { should include(:cpf => "09532034765") }
    specify { should include(:url => "/go_back") }
  
  end

end