class BuscarVias < ActiveRecord::Base
  
  registros = Registro.all
  registros.each do |registro|
    registro.buscar_via
  end
  
end