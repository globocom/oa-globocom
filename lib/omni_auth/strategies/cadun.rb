module OmniAuth
  module Strategies
    class Cadun
      include OmniAuth::Strategy
      
      attr_reader :glb_id, :url, :params
      
      def initialize(app, options = {})
        super(app, :cadun, options)
      end
      
      def request_phase
        redirect "https://login.dev.globoi.com/login/#{service_id}"
      end
      
      def auth_hash
        @params = CGI.parse(URI.parse(env['REQUEST_URI']).query)
        @glb_id = params['GLBID'].first
        @url = params['url'].first
        
        { :GLBID => glb_id,
          :url => url,
          :id => user.id,
          :email => user.email,
          :status => user.status,
          :username => user.login,
          :name => user.name,
          :address => user.address,
          :suburb => user.suburb,
          :city => user.city,
          :state => user.state,
          :country => user.country,
          :gender => user.gender,
          :birthday =>  user.birthday.strftime('%d/%m/%Y'),
          :mobile => user.mobile,
          :phone => user.phone,
          :cpf => user.cpf }
      end
      
      protected
      def user
        @user ||= ::Cadun::User.new(glb_id, env['REMOTE_ADDR'], service_id)
      end
      
      def service_id
        @options[:service_id]
      end
    end
  end
end