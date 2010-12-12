class AtualizarBD < ActiveRecord::Base
  
  Evento.update_all({:ativo => false}, ["ativo = 1 AND data_hora < ?", Time.now - 30.minutes])
  Transito.update_all({:ativo => false}, ["ativo = 1 AND updated_at < ?", Time.now - 30.minutes])
  
end