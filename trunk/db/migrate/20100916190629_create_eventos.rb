class CreateEventos < ActiveRecord::Migration
  def self.up
    create_table :eventos do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :data_hora
      t.string :descricao
      t.binary :foto
      t.integer :evento_tipo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :eventos
  end
end
