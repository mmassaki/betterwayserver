class CalcularTransito < ActiveRecord::Base
  
  registros = Registro.all
  registros.each do |registro|
    Transito.informar registro
  end
  
end