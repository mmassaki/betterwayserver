class Registro < ActiveRecord::Base
  
  def buscar_via
    latlng = "#{latitude},#{longitude}"
    url = URI.parse('http://maps.googleapis.com')
    http = Net::HTTP.new(url.host, url.port)
    resp = http.get("/maps/api/geocode/json?latlng=#{latlng}&sensor=true")
    json = ActiveSupport::JSON.decode(resp.body)
    
    if json["results"].size.zero?
      # nenhum endereco encontrado
      return
    end
    
    json["results"].each do |result|
      if result["types"].include? "street_address"
        result["address_components"].each do |node|
          node["types"].each do |type|
            case type
            when "street_number"
              self.via_num = node["long_name"]
            when "route"
              self.via = node["long_name"]
            when "sublocality"
              self.bairro = node["long_name"]
            when "locality"
              self.cidade = node["long_name"]
            when "administrative_area_level_1"
              self.estado = node["long_name"]
            when "country"
              self.pais = node["long_name"]
            when "postal_code"
              self.cep = node["long_name"]
            end
          end
        end
        break
      end
    end
    self.save
    Transito.informar self
  end
  
end
