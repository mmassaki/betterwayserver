require 'polyline_decoder'
require 'net/http'
require 'uri'

class RotaController < ApplicationController
  
  def tracar
    origem = params[:origem]
    destino = params[:destino]
    
    url = URI.parse('http://maps.googleapis.com')
    http = Net::HTTP.new(url.host, url.port)
    resp = http.get("/maps/api/directions/json?origin=#{origem}&destination=#{destino}&sensor=false")
    json = ActiveSupport::JSON.decode(resp.body)
    
    if json["routes"].size.zero?
      render :text => "Nenhuma rota encontrada"
      return
    end
    
    polyline = json["routes"][0]["overview_polyline"]["points"]
    
    polyline_decoder = PolylineDecoder.new
    line_arr = polyline_decoder.decode(polyline)
    
    rota = Hash.new
    rota["status"] = json["status"]
    leg = json["routes"][0]["legs"][0]
    rota["distancia"] = leg["distance"]
    rota["duracao"] = leg["duration"]
    rota["polyline"] = line_arr
    
    render :json => rota
  end
  
end
