require 'polyline_decoder'
require 'net/http'
require 'uri'

class RotaController < ApplicationController
  
  def index
    line = "ngynCxaw{GxX{]nUm\\??|D_FnKmElLcE??t@UfBK~A]nJeF??`AlB??|HiG??g@{@??kBkEo@kD{CqD_E_Ae@u@??QP??i@ZoA\\_CT{@IeAc@uCeB{@eAmBkD{@}BoAsHaBgAqAM???{AcAoDeEaFwD}BcLaFeFgC??dEwKvAmL??sW_D??zAiN??qIaD??o@lB"
    polyline_decoder = PolylineDecoder.new
    line_arr = polyline_decoder.decode(line)
    line_arr.each do |ln|
      puts ln[0].to_s + ", " + ln[1].to_s
    end
    render :text => 'aaaa'
  end
  
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
