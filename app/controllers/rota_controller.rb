require 'polyline_decoder'

class RotaController < ApplicationController
  
  DIST_TOLERANCE = 0.001
  
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
        x0 = line_arr[i-1][0]
        y0 = line_arr[i-1][1]
        x = line_arr[i][0]
        y = line_arr[i][1]
        a = y0 - y
        b = x - x0
        c = x0*y - x*y0
        
        x_range = (x0 < x)? x0..x : x..x0
        y_range = (y0 < y)? y0..y : y..y0
        
        eventos.each do |evento|
          if x_range.include?(evento.latitude) && y_range.include?(evento.longitude)
            dist = ((a*evento.latitude + b*evento.longitude + c).abs) / (Math.sqrt(a**2 + b**2))
            if dist <= DIST_TOLERANCE
              logger.info "Evento proximo da rota (#{x0}, #{y0}) -> (#{x}, #{y})"
              logger.info "coordenadas: (#{evento.latitude}, #{evento.longitude})"
              logger.info "distancia = #{dist}"
              rota["peso"] += 2
            end
          end
        end

        transitos.each do |transito|
          d11 = Math.sqrt((x0 - transito.latitude_ponto1)**2 + (y0 - transito.longitude_ponto1)**2)
          d22 = Math.sqrt((x - transito.latitude_ponto2)**2 + (y - transito.longitude_ponto2)**2)
          d12 = Math.sqrt((x0 - transito.latitude_ponto2)**2 + (y0 - transito.longitude_ponto2)**2)
          d21 = Math.sqrt((x - transito.latitude_ponto1)**2 + (y - transito.longitude_ponto1)**2)
          
          if (d11 <= DIST_TOLERANCE && d22 <= DIST_TOLERANCE) || (d12 <= DIST_TOLERANCE && d21 <= DIST_TOLERANCE)
            logger.info "Transito proximo da rota (#{x0}, #{y0}) -> (#{x}, #{y})"
            logger.info "ponto 1: (#{transito.latitude_ponto1}, #{transito.longitude_ponto1})"
            logger.info "ponto 2: (#{transito.latitude_ponto2}, #{transito.longitude_ponto2})"
            logger.info "intensidade = #{transito.intensidade}"
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
