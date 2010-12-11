class UpdateRegistros < ActiveRecord::Migration
  def self.up
    add_column :registros, :via_num, :string
    add_column :registros, :bairro, :string
    add_column :registros, :cidade, :string
    add_column :registros, :estado, :string
    add_column :registros, :pais, :string
    add_column :registros, :cep, :string
  end

  def self.down
    remove_column :registros, :via_num
    remove_column :registros, :bairro
    remove_column :registros, :cidade
    remove_column :registros, :estado
    remove_column :registros, :pais
    remove_column :registros, :cep
  end
end
