require 'oa-core'

module OmniAuth
  module Strategies
    class Cadun
      include OmniAuth::Strategy
      
      def initialize(app, service_id, options = {})
        options.merge!(:service_id => service_id)
        super(app, :cadun, options)
      end
      
      def request_phase
        redirect "https://login.dev.globoi.com/login/#{service_id}"
      end
      
      def auth_hash
        params = CGI.parse(URI.parse(env["REQUEST_URI"]).query)
        @glb_id = params["GLBID"].first
        
        { :GLBID => @glb_id,
          :url => params["url"].first,
          :user_info => user_info }
      end
      
      protected
      def user_info
        user_info = simple_user_info
        user_info.merge!(full_user_info) if @options[:full]
        user_info
      end
      
      def simple_user_info
        { :id => gateway.content.xpath("usuarioID").text,
          :email => gateway.content.xpath("emailPrincipal").text,
          :status => gateway.content.xpath("status").text,
          :username => gateway.content.xpath("username").text }
      end
      
      def full_user_info
        { :name => gateway.full_content.xpath("nome").text,
          :city => gateway.full_content.xpath("cidade/nome").text,
          :state => gateway.full_content.xpath("estado/sigla").text,
          :gender => gateway.full_content.xpath("sexo").text,
          :birthday =>  Time.parse(gateway.full_content.xpath("dataNascimento").text).strftime('%d/%m/%Y'),
          :mobile => "#{gateway.full_content.xpath("telefoneCelularDdd").text} #{gateway.full_content.xpath("telefoneCelular").text}",
          :phone => "#{gateway.full_content.xpath("telefoneResidencialDdd").text} #{gateway.full_content.xpath("telefoneResidencial").text}" }
      end
      
      def gateway
        @gateway ||= OACadun::Gateway.new(@glb_id, env["REMOTE_ADDR"], service_id)
      end
      
      def service_id
        @options[:service_id]
      end
    end
  end
end