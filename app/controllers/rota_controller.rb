require 'polyline_decoder'

class RotaController < ApplicationController
  
  DIST_TOLERANCE = 0.0001
  
  def tracar
    origem = params[:origem]
    destino = params[:destino]
    
    url = URI.parse('http://maps.googleapis.com')
    http = Net::HTTP.new(url.host, url.port)
    resp = http.get("/maps/api/directions/json?origin=#{origem}&destination=#{destino}&alternatives=true&sensor=true")
    json = ActiveSupport::JSON.decode(resp.body)
    
    if json["routes"].size.zero?
      render :text => "Nenhuma rota encontrada"
      return
    end
    
    eventos = Evento.where(:ativo => true)
    transitos = Transito.where(:ativo => true)
    
    polyline_decoder = PolylineDecoder.new

    melhor_rota = nil
    json["routes"].each do |rota|
      
      polyline = rota["overview_polyline"]["points"]
      line_arr = polyline_decoder.decode(polyline)
      
      logger.info "Analisando rota #{rota["summary"]}"
      rota["peso"] = 0
      
      for i in 1..line_arr.size-1 do
        x = line_arr[i][0]
        y = line_arr[i][1]
        x0 = line_arr[i-1][0]
        y0 = line_arr[i-1][1]
        a = (y - y0)/(x - x0)
        c = y - a*x
        b = -1
        
        eventos.each do |evento|
          dist = (a*evento.latitude + b*evento.longitude + c).abs/Math.sqrt(a**2 + b**2)
          if dist < DIST_TOLERANCE
            logger.info "Evento proximo da rota (#{evento.latitude}, #{evento.longitude})"
            logger.info "distancia = #{dist}"
            rota["peso"] += 2
          end
        end
        
        transitos.each do |transito|
          dist1 = (a*transito.latitude_ponto1 + b*transito.longitude_ponto1 + c).abs/Math.sqrt(a**2 + b**2)
          dist2 = (a*transito.latitude_ponto2 + b*transito.longitude_ponto2 + c).abs/Math.sqrt(a**2 + b**2)
          if dist1 < DIST_TOLERANCE || dist2 < DIST_TOLERANCE
            logger.info "Transito proximo da rota"
            logger.info "ponto 1: (#{transito.latitude_ponto1}, #{transito.longitude_ponto1})"
            logger.info "ponto 2: (#{transito.latitude_ponto2}, #{transito.longitude_ponto2})"
            logger.info "intensidade = #{transito.intensidade}"
            logger.info "distancia: ponto1 = #{dist1}, ponto2 = #{dist2}"
            logger.debug "ROTA ponto inicial: (#{x}, #{y}), ponto final: (#{x0}, #{y0})"
            rota["peso"] += 4 - transito.intensidade.round
          end
        end
      end
      
      logger.debug "Peso da rota = #{rota["peso"]}"
      
      if melhor_rota.nil? || rota["peso"] < melhor_rota["peso"]
        melhor_rota = rota
        melhor_rota["polyline"] = line_arr
        logger.info "Nova rota minima"
        logger.info "nome: #{melhor_rota["summary"]}"
        logger.info "peso = #{melhor_rota["peso"]}"
      end
      
    end
    
    rota = Hash.new
    rota["status"] = json["status"]
    rota["nome"] = melhor_rota["summary"]
    leg = melhor_rota["legs"][0]
    rota["distancia"] = leg["distance"]
    rota["duracao"] = leg["duration"]
    rota["polyline"] = melhor_rota["polyline"]
    
    render :json => rota
  end
  
end
