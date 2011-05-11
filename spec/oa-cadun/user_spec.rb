require 'spec_helper'

describe OACadun::User do
  
  before do
    FakeWeb.register_uri(:put, "http://isp-authenticator.dev.globoi.com:8280/ws/rest/autorizacao",
                         :body => File.join(File.dirname(__FILE__), "..", "support", "fixtures", "autorizacao.xml"))

    FakeWeb.register_uri(:get, "http://isp-authenticator.dev.globoi.com:8280/cadunii/ws/resources/pessoa/21737810", 
                         :body => File.join(File.dirname(__FILE__), "..", "support", "fixtures", "pessoa.xml"))
  end
  
  subject { OACadun::User.new("GLB_ID", "127.0.0.1", 2626) }
  
  describe "#id" do
    it { subject.id.should == "21737810" }
  end
  
  describe "#name" do
    it { subject.name.should == "Fabricio Rodrigo Lopes" }
  end
  
  describe "#birthday" do
    it { subject.birthday.should == Time.mktime(1983, 02, 22) }
  end
  
  describe "#phone" do
    it { subject.phone.should == "21 22881060" }
  end
  
  describe "#mobile" do
    it { subject.mobile.should == "21 99999999" }
  end
  
  describe "#email" do
    it { subject.email.should == "fab1@spam.la"}
  end
  
  describe "#gender" do
    it { subject.gender.should == "MASCULINO" }
  end
  
  describe "#city" do
    it { subject.city.should == "Rio de Janeiro"}
  end
  
  describe "#state" do
    it { subject.state.should == "RJ" }
  end
  
  describe "#status" do
    it { subject.status.should == "ATIVO" }
  end
  
  describe "#address" do
    it { subject.address.should == "Rua Uruguai, 59"}
  end
  
  describe "#suburb" do
    it { subject.suburb.should == "Andaraí" }
  end
  
  describe "#cpf" do
    it { subject.cpf.should == "09532034765" }
  end
  
  describe "#login" do
    it { subject.login.should == "fabricio_fab1" }
  end
  
  describe "#country" do
    it { subject.country.should == "Brasil" }
  end
end