class BuscarVias < ActiveRecord::Base
  
  registros = Registro.where("via IS NOT NULL")
  registros.each do |registro|
    registro.buscar_via
  end
  
end