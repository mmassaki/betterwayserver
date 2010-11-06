class CreateEventoTipos < ActiveRecord::Migration
  def self.up
    create_table :evento_tipos do |t|
      t.string :nome
      t.binary :icone

      t.timestamps
    end
  end

  def self.down
    drop_table :evento_tipos
  end
end
