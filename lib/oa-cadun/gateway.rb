require 'nokogiri'

module OACadun
  class Gateway
    def initialize(glb_id, ip, service_id)
      @glb_id = glb_id
      @ip = ip
      @service_id = service_id
    end

    def content      
      @content ||= Nokogiri::XML(authentication).children
    end
  
    def full_content
      @full_content ||= Nokogiri::XML(resource).children
    end

    protected
    def authentication
      @authentication ||= connection.put("/ws/rest/autorizacao", xml, {'Content-Type' => 'text/xml'}).body
    end
  
    def resource
      @resource ||= connection.get("/cadunii/ws/resources/pessoa/#{content.xpath("usuarioID").text}", {'Content-Type' => 'text/xml'}).body
    end

    def connection
      @connection ||= Net::HTTP.new("isp-authenticator.dev.globoi.com", 8280)
    end

    def xml   
      "<usuarioAutorizado><glbId>#{@glb_id}</glbId><ip>#{@ip}</ip><servicoID>#{@service_id}</servicoID></usuarioAutorizado>"
    end
  end
end