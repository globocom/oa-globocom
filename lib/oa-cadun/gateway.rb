module OACadun
  class Gateway
    def initialize(glb_id, ip, service_id)
      @glb_id, @ip, @service_id = glb_id, ip, service_id
    end
  
    def content
      @content ||= Nokogiri::XML(resource).children
    end

    def authorization
      @authorization ||= Nokogiri::XML(connection.put("/ws/rest/autorizacao", "<usuarioAutorizado><glbId>#{@glb_id}</glbId><ip>#{@ip}</ip><servicoID>#{@service_id}</servicoID></usuarioAutorizado>", {'Content-Type' => 'text/xml'}).body).children
    end
  
    def resource
      @resource ||= connection.get("/cadunii/ws/resources/pessoa/#{authorization.xpath("usuarioID").text}", {'Content-Type' => 'text/xml'}).body
    end

    def connection
      @connection ||= Net::HTTP.new(*(development? ? ["isp-authenticator.dev.globoi.com", 8280] : ["autenticacao.globo.com", 8080] ))
    end
   
    protected
    def development?
      if defined?(Rails)
        Rails.env.development?
      else
        true
      end
    end
  end
end