require 'spec_helper'

describe OmniAuth::Strategies::Cadun do
  describe "#request_phase" do
    before do
      @status, @headers, @body = OmniAuth::Strategies::Cadun.new(app, :service_id => 1).request_phase
    end
    
    describe "status" do
      subject { @status }
      specify { should == 302 }
    end
    
    describe "headers" do
      subject { @headers }
      specify { should include("Location" => "https://login.dev.globoi.com/login/1") }
    end
  end
  
  describe "#auth_hash" do
    subject do
      OmniAuth::Strategies::Cadun.new(app, :service_id => 1).auth_hash
    end
    
    specify { should include(:GLBID => "GLB_ID") }
    specify { should include(:id => "21737810") }
    specify { should include(:email => "fab1@spam.la") }
    specify { should include(:status => "ATIVO") }
    specify { should include(:username => "fabricio_fab1") }
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
  end
end