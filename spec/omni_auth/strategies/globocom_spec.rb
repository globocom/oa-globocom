# encoding: utf-8
require 'spec_helper'

describe OmniAuth::Strategies::GloboCom do

  let(:app) { lambda { |env| [200, {}, ['Hello']] } }
  let(:strategy) { OmniAuth::Strategies::GloboCom.new app, :service_id => 1, :config => "#{File.dirname(__FILE__)}/../../support/fixtures/config.yml" }
  
  describe "#request_phase" do
    context "when it has a referer" do
      before do
        strategy.call! Rack::MockRequest.env_for("http://test.localhost/auth/cadun", "rack.session" => {}, "HTTP_HOST" => "test.localhost")

        @status, @headers, @body = strategy.request_phase
      end

      describe "status" do
        it { @status.should == 302 }
      end

      describe "headers" do
        it { @headers.should include("Location" => "https://login.dev.globoi.com/login/1?url=http%3A%2F%2Ftest.localhost%2Fauth%2Fcadun%2Fcallback") }
      end
    end
    
    context "when it has a referer and a different port" do
      before do
        strategy.call!(Rack::MockRequest.env_for("http://test.localhost:8080/auth/cadun", "rack.session" => {}, "HTTP_HOST" => "test.localhost", "SERVER_PORT" => "8080"))

        @status, @headers, @body = strategy.request_phase
      end

      describe "status" do
        it { @status.should == 302 }
      end

      describe "headers" do
        it { @headers.should include("Location" => "https://login.dev.globoi.com/login/1?url=http%3A%2F%2Ftest.localhost%3A8080%2Fauth%2Fcadun%2Fcallback") }
      end
    end
  end
  
  describe "#callback_phase" do
    context "when the authorization fails" do
      before do
        stub_fail_requests
        strategy.call! Rack::MockRequest.env_for("http://localhost/auth/cadun/callback?GLBID=GLBID", "rack.session" => {}, "REMOTE_ADDR" => "127.0.0.1")
      end

      it { strategy.env['omniauth.auth'].should be_nil }
      it { strategy.env['omniauth.error'].should == "NAO_AUTORIZADO" }
      it { strategy.env['omniauth.error.type'].should == :NAO_AUTORIZADO }
    end
    
    context "when the authorization succeeds" do
      before do
        stub_requests
        strategy.call! Rack::MockRequest.env_for("http://localhost/auth/cadun/callback?GLBID=GLBID", "rack.session" => {}, "REMOTE_ADDR" => "127.0.0.1")
      end

      it { strategy.env['omniauth.auth'].should_not be_nil }
      it { strategy.env['omniauth.error'].should be_nil }
      it { strategy.env['omniauth.error.type'].should be_nil }
    end
  end
  
  describe "#auth_hash" do
    before do
      stub_requests
      strategy.call! Rack::MockRequest.env_for("http://localhost?GLBID=GLBID&url=/go_back", "rack.session" => {}, "REMOTE_ADDR" => "127.0.0.1")
    end
    
    describe ":uid" do
      it { strategy.auth_hash[:uid].should == "21737810" }
    end
    
    describe ":provider" do
      it { strategy.auth_hash[:provider].should == "cadun" }
    end
    
    describe ":user_info" do
      subject { strategy.auth_hash[:info] }
      
      it { should include :address => "Rua Uruguai, 59" }
      it { should include :birthday => "22/02/1983" }
      it { should include :city => "Rio de Janeiro" }
      it { should include :country => "Brasil" }
      it { should include :cpf => "09532034765" }
      it { should include :email => "fab1@spam.la" }
      it { should include :gender => "MASCULINO" }
      it { should include :cadun_id => "21737810" }
      it { should include :mobile => "21 99999999" }
      it { should include :name => "Fabricio Rodrigo Lopes" }
      it { should include :neighborhood => "Andaraí" }
      it { should include :login => "fabricio_fab1" }
      it { should include :phone => "21 22881060" }
      it { should include :state => "RJ" }
      it { should include :status => "ATIVO" }
      it { should include :user_type => "NAO_ASSINANTE" }
      it { should include :zipcode => "20510060" }
      it { should include :complement => "807" }
    end
    
    describe ":credentials" do
      subject { strategy.auth_hash[:credentials] }
      
      it { should include(:GLBID => "GLBID") }
      it { should include(:url => "/go_back") }
    end
  end
  
  describe "#client_ip" do
    it 'should return ip from REMOTE_ADDR when it comes alone' do
      strategy.call! Rack::MockRequest.env_for "http://test.localhost/auth/cadun", "rack.session" => {}, 'REMOTE_ADDR' =>  '200.201.0.15'
      strategy.client_ip.should == '200.201.0.15'
    end

    it 'should return ip from REMOTE_ADDR when HTTP_X_FORWARDED_FOR is empty' do
      strategy.call! Rack::MockRequest.env_for "http://test.localhost/auth/cadun", "rack.session" => {}, 'REMOTE_ADDR' =>  '200.201.0.20', 'HTTP_X_FORWARDED_FOR' => ''
      strategy.client_ip.should == '200.201.0.20'
    end

    it 'should return ip from HTTP_X_FORWARDED_FOR when it comes alone' do
      strategy.call! Rack::MockRequest.env_for "http://test.localhost/auth/cadun", "rack.session" => {}, 'HTTP_X_FORWARDED_FOR' =>  '201.10.0.15'
      strategy.client_ip.should == '201.10.0.15'
    end

    it 'should return ip from HTTP_X_FORWARDED_FOR even if REMOTE_ADDR is present' do
      strategy.call! Rack::MockRequest.env_for "http://test.localhost/auth/cadun", "rack.session" => {}, 'REMOTE_ADDR' =>  '200.201.0.15', 'HTTP_X_FORWARDED_FOR' =>  '201.10.0.16'
      strategy.client_ip.should == '201.10.0.16'
    end

    it 'should always return the last ip from HTTP_X_FORWARDED_FOR' do
      strategy.call! Rack::MockRequest.env_for "http://test.localhost/auth/cadun", "rack.session" => {}, 'HTTP_X_FORWARDED_FOR' =>  '201.10.0.15, 201.10.0.16, 201.10.0.17'
      strategy.client_ip.should == '201.10.0.17'
    end
  end

  describe "#log_env" do
    it 'should render the log' do
      stub_fail_requests
      Timecop.travel(Time.now) do
        strategy.call! Rack::MockRequest.env_for("http://localhost/auth/cadun/callback?GLBID=GLBID", "rack.session" => {}, "REMOTE_ADDR" => "127.0.0.1")
        strategy.log_env.should == "#{Time.now.strftime("%d/%m/%Y %H:%M")} - SERVER_NAME: localhost | PATH_INFO: /auth/cadun/callback | QUERY_STRING: GLBID=GLBID"
      end
    end
  end
  
  describe "#log_exception" do
    it "should render the log" do
      stub_fail_requests
      
      Timecop.travel(Time.local(2011, 11, 24, 1, 2, 0)) do
        strategy.call! Rack::MockRequest.env_for("http://localhost/auth/cadun/callback?GLBID=GLBID", "rack.session" => {}, "REMOTE_ADDR" => "127.0.0.1")
      
        exception = Exception.new 'NAO_AUTORIZADO'
        strategy.log_exception(exception).should == "24/11/2011 01:02 - SERVER_NAME: localhost | PATH_INFO: /auth/cadun/callback | QUERY_STRING: GLBID=GLBID | EXCEPTION: NAO_AUTORIZADO"
      end
    end
  end
  
  describe "logging failures" do    
    it "should log the failure" do
      logger = double('logger')
      
      strategy = OmniAuth::Strategies::GloboCom.new app, :service_id => 1, :config => "#{File.dirname(__FILE__)}/../../support/fixtures/config.yml", :logger => logger
      stub_fail_requests
      
      Timecop.travel(Time.local(2011, 11, 24, 1, 2, 0)) do
        logger.should_receive(:error).with("24/11/2011 01:02 - SERVER_NAME: localhost | PATH_INFO: /auth/cadun/callback | QUERY_STRING: GLBID=GLBID | EXCEPTION: NAO_AUTORIZADO")
        strategy.stub!(:call_app!).and_raise Exception
        strategy.stub!(:logger).and_return logger
      
        strategy.call! Rack::MockRequest.env_for "http://localhost/auth/cadun/callback?GLBID=GLBID", "rack.session" => {}, "REMOTE_ADDR" => "127.0.0.1"
      end
    end
    
    it "should not log the failure" do
      stub_fail_requests
      
      strategy.stub!(:call_app!).and_raise Exception
      strategy.should_not_receive :log_exception
      
      strategy.call! Rack::MockRequest.env_for "http://localhost/auth/cadun/callback?GLBID=GLBID", "rack.session" => {}, "REMOTE_ADDR" => "127.0.0.1"
    end
  end
end
