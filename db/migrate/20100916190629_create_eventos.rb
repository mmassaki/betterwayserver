class CreateEventos < ActiveRecord::Migration
  def self.up
    create_table :eventos do |t|
      t.float :latitude
      t.float :longitude
      t.datetime :data_hora
      t.string :descricao
      t.binary :foto, :limit => 16777215
      t.integer :evento_tipo_id
      t.string :dispositivo_id
      t.boolean :ativo, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :eventos
  end
end
