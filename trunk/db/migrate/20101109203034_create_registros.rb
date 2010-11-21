class CreateRegistros < ActiveRecord::Migration
  def self.up
    create_table :registros do |t|
      t.float :latitude
      t.float :longitude
      t.string :via
      t.float :velocidade
      t.datetime :data_hora
      t.string :dispositivo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :registros
  end
end
