require 'cadun/config'
require 'cadun/user'
require 'cadun/gateway'

module OmniAuth
  module Strategies
    class Cadun
      include OmniAuth::Strategy
      include ::Cadun
      
      def initialize(app, options = {})
        Config.load_file(options[:config])
        
        super(app, :cadun, options)
      end
      
      def request_phase
        redirect "#{Config.login_url}/#{service_id}?url=#{callback_url}"
      end
      
      def auth_hash
        self.class.build_auth_hash(user, request)
      end
      
      def self.build_auth_hash(user, request = nil)
        hash = { :provider => "cadun", :uid => user.id, :user_info => user.to_hash.merge(:birthday =>  user.birthday.strftime('%d/%m/%Y')) }
        hash[:user_info].merge!(:GLBID => request.params['GLBID'], :url => request.params['url']) if request
        
        hash
      end
      
      protected
      def user
        @user ||= User.new(:glb_id => request.params['GLBID'], :ip => env['REMOTE_ADDR'], :service_id => service_id)
      end
      
      def service_id
        @options[:service_id]
      end
      
      def callback_url
        uri = request.env['HTTP_HOST']
        port = request.env['SERVER_PORT'] == "80" ? nil : ":#{request.env['SERVER_PORT']}"
        scheme = request.env['rack.url_scheme']
        
        callback_url = "#{scheme}://#{uri}#{port}/auth/cadun/callback"
        URI.escape(callback_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end
    end
  end
end