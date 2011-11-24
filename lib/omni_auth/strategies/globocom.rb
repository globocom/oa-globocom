require 'rubygems'
require 'oa-core'
require 'cadun'
require 'cadun/config'

module OmniAuth
  module Strategies
    class GloboCom
      include OmniAuth::Strategy
      
      attr_reader :logger
      
      def initialize(app, opts = {})
        Cadun::Config.load_file opts[:config]
        
        @logger = opts[:logger]
        super app, :cadun, opts
      end
      
      def request_phase
        redirect "#{Cadun::Config.login_url}/#{service_id}?url=#{callback_url}"
      end
      
      def callback_phase
        begin
          super
        rescue Exception => e
          logger.error log_exception(e) if logger
          
          fail! e.message, e.message
        end
      end
      
      def auth_hash
        hash = { :provider => "cadun", :uid => user.id, :info => user.to_hash.merge(:birthday => user.birthday.strftime('%d/%m/%Y')) }
        hash[:credentials] = { :GLBID => request.params['GLBID'], :url => request.params['url'] } if request
        
        hash
      end
      
      def user
        @user ||= Cadun::User.new :glb_id => request.params['GLBID'], :ip => client_ip, :service_id => service_id
      end
      
      def service_id
        @options[:service_id]
      end
      
      def callback_url
        uri = request.env['HTTP_HOST']
        port = request.env['SERVER_PORT'] == "80" ? nil : ":#{request.env['SERVER_PORT']}"
        scheme = request.env['rack.url_scheme']
        
        callback_url = "#{scheme}://#{uri}#{port}/auth/#{name}/callback"
        URI.escape callback_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
      end
      
      def client_ip
        env['HTTP_X_FORWARDED_FOR'].present? ? env['HTTP_X_FORWARDED_FOR'].split(',').last.strip : env['REMOTE_ADDR']
      end
      
      def log_env
        "#{Time.now.strftime("%d/%m/%Y %H:%M")} - SERVER_NAME: #{request.env['SERVER_NAME']} | PATH_INFO: #{request.env['PATH_INFO']} | QUERY_STRING: #{request.env['QUERY_STRING']}"
      end
      
      def log_exception(exception)
        "#{log_env} | EXCEPTION: #{exception}"
      end
    end
  end
end
