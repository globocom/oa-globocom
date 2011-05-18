module OmniAuth
  module Strategies
    class Cadun
      include OmniAuth::Strategy
      
      def initialize(app, options = {})
        super(app, :cadun, options)
      end
      
      def request_phase
        redirect "https://login.dev.globoi.com/login/#{service_id}?url=#{callback_url}"
      end
      
      def auth_hash
        { 
          :provider => "cadun",
          :uid => user.id,
          :user_info => {
            :id => user.id,
            :GLBID => request.params['GLBID'],
            :url => request.params['url'],          
            :email => user.email,
            :status => user.status,
            :nickname => user.login,
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
            :cpf => user.cpf
          }
        }
      end
      
      protected
      def user
        @user ||= ::Cadun::User.new(request.params['GLBID'], env['REMOTE_ADDR'], service_id)
      end
      
      def service_id
        @options[:service_id]
      end
      
      def callback_url
        uri = URI.parse(request.referer)
        port = uri.port == 80 ? nil : ":#{uri.port}"
        
        callback_url = "http://#{uri.host}#{port}/auth/cadun/callback"
        URI.escape(callback_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end
    end
  end
end