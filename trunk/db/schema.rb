# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101211191412) do

  create_table "eventos", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "data_hora"
    t.string   "descricao"
    t.binary   "foto",           :limit => 16777215
    t.integer  "evento_tipo_id"
    t.string   "dispositivo_id"
    t.boolean  "ativo",                              :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registros", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "via"
    t.float    "velocidade"
    t.datetime "data_hora"
    t.string   "dispositivo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "via_num"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "estado"
    t.string   "pais"
    t.string   "cep"
  end

  create_table "transitos", :force => true do |t|
    t.float    "latitude_ponto1"
    t.float    "longitude_ponto1"
    t.float    "latitude_ponto2"
    t.float    "longitude_ponto2"
    t.string   "polyline"
    t.string   "via"
    t.string   "via_num"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "estado"
    t.string   "pais"
    t.string   "cep"
    t.float    "intensidade"
    t.integer  "reportado"
    t.boolean  "ativo",            :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
