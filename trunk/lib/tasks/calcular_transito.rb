class CalcularTransito < ActiveRecord::Base
  
  registros = Registro.where("via IS NOT NULL")
  registros.each do |registro|
    Transito.informar registro
  end
  
end