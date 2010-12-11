class CreateTransitos < ActiveRecord::Migration
  def self.up
    create_table :transitos do |t|
      t.float :latitude_ponto1
      t.float :longitude_ponto1
      t.float :latitude_ponto2
      t.float :longitude_ponto2
      t.string :polyline
      t.string :via
      t.string :via_num
      t.string :bairro
      t.string :cidade
      t.string :estado
      t.string :pais
      t.string :cep
      t.float :intensidade
      t.integer :reportado
      t.boolean :ativo, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :transitos
  end
end
