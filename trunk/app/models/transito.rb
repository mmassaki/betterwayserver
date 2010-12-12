require 'polyline_decoder'

class Transito < ActiveRecord::Base
  
  serialize :polyline
  
  VEL_1 = 10
  VEL_2 = 40
  VEL_3 = 60

  def self.informar registro
    
    if transito = where({:via => registro.via, :via_num => registro.via_num, :bairro => registro.bairro, :cidade => registro.cidade, :estado => registro.estado, :pais => registro.pais, :cep => registro.cep}).first
      # se jah tem informacao de transito
      intensidade = calcula_intensidade registro.velocidade
      if transito.ativo
        transito.intensidade = (transito.intensidade * transito.reportado + intensidade) / (transito.reportado + 1)
        transito.reportado += 1
      else
        transito.intensidade = intensidade
        transito.reportado = 1
      end
    else
      # caso nao tenha, cria uma
      num = registro.via_num.split('-')
      origem = URI.escape("#{registro.via}, #{num[0]} - #{registro.bairro}, #{registro.cidade}, #{registro.cep}, #{registro.pais}")
      destino = URI.escape("#{registro.via}, #{num[1]} - #{registro.bairro}, #{registro.cidade}, #{registro.cep}, #{registro.pais}")
    
      url = URI.parse('http://maps.googleapis.com')
      http = Net::HTTP.new(url.host, url.port)
      resp = http.get("/maps/api/directions/json?origin=#{origem}&destination=#{destino}&sensor=true")
      p resp.body
      json = ActiveSupport::JSON.decode(resp.body)
    
      if json["routes"].size.zero?
        # Nenhuma rota encontrada
        return
      end
    
      polyline = json["routes"][0]["overview_polyline"]["points"]
    
      polyline_decoder = PolylineDecoder.new
      line_arr = polyline_decoder.decode(polyline)
    
      transito = new
      leg = json["routes"][0]["legs"][0]
      transito.latitude_ponto1 = leg["start_location"]["lat"]
      transito.longitude_ponto1 = leg["start_location"]["lng"]
      transito.latitude_ponto2 = leg["end_location"]["lat"]
      transito.longitude_ponto2 = leg["end_location"]["lng"]
      transito.polyline = line_arr
      transito.via = registro.via
      transito.via_num = registro.via_num
      transito.bairro = registro.bairro
      transito.cidade = registro.cidade
      transito.estado = registro.estado
      transito.pais = registro.pais
      transito.cep = registro.cep
      transito.intensidade = calcula_intensidade registro.velocidade
      transito.reportado = 1
    end
    transito.save
    
  end
  
  private #----------------------------------------
  
  def self.calcula_intensidade velocidade
    velocidade *= 3.6
    return case
    when velocidade < VEL_1
      1
    when velocidade > VEL_1 && velocidade < VEL_2
      2
    when velocidade > VEL_2 && velocidade < VEL_3
      3
    when velocidade > VEL_3
      4
    end
  end
  
end
