module OACadun
  class User
    attr_reader :gateway
    
    { "id"                       => "id", 
      "nome"                     => "name", 
      "emailPrincipal"           => "email", 
      "sexo"                     => "gender",
      "bairro"                   => "suburb", 
      "cidade/nome"              => "city", 
      "estado/sigla"             => "state",
      "pais/nome"                => "country" }.each do |path, method|
      define_method(method) { gateway.content.xpath(path).text }
    end
    
    def initialize(glb_id, ip, service_id)
      @gateway = Gateway.new(@glb_id, @ip, @service_id)
    end
    
    def address
      "#{endereco}, #{numero}"
    end
    
    def birthday
      Time.parse(dataNascimento)
    end
  
    def phone
      "#{telefoneResidencialDdd} #{telefoneResidencial}"
    end
    
    def mobile
      "#{telefoneCelularDdd} #{telefoneCelular}"
    end
    
    def method_missing(method)
      gateway.content.xpath(method.to_s).text
    end
  end
end