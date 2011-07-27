require 'rubygems'
require 'oa-core'
require 'cadun'
require 'cadun/config'

module OmniAuth
  module Strategies
    class GloboCom
      include OmniAuth::Strategy
      
      def initialize(app, options = {})
        Cadun::Config.load_file(options[:config])
        
        super(app, :cadun, options)
      end
      
      def request_phase
        redirect "#{Cadun::Config.login_url}/#{service_id}?url=#{callback_url}"
      end
      
      def callback_phase
        begin
          super
        rescue => e
          fail!(e.message, e.message)
        end
      end
      
      def auth_hash
        self.class.build_auth_hash(user, request)
      end
      
      def user
        @user ||= Cadun::User.new(:glb_id => request.params['GLBID'], :ip => client_ip, :service_id => service_id)
      end
      
      def service_id
        @options[:service_id]
      end
      
      def callback_url
        uri = request.env['HTTP_HOST']
        port = request.env['SERVER_PORT'] == "80" ? nil : ":#{request.env['SERVER_PORT']}"
        scheme = request.env['rack.url_scheme']
        
        callback_url = "#{scheme}://#{uri}#{port}/auth/#{name}/callback"
        URI.escape(callback_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end
      
      def client_ip
        if env['HTTP_X_FORWARDED_FOR'] and not env['HTTP_X_FORWARDED_FOR'].empty?
          env['HTTP_X_FORWARDED_FOR'].split(',').last.strip
        else
          env['REMOTE_ADDR']
        end
      end
      
      def self.build_auth_hash(user, request = nil)
        hash = { :provider => "cadun", :uid => user.id, :user_info => user.to_hash.merge(:birthday =>  user.birthday.strftime('%d/%m/%Y')) }
        hash[:user_info].merge!(:GLBID => request.params['GLBID'], :url => request.params['url']) if request
        
        hash
      end
    end
  end
end
