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

ActiveRecord::Schema.define(:version => 20101109203034) do

  create_table "evento_tipos", :force => true do |t|
    t.string   "nome"
    t.binary   "icone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eventos", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "data_hora"
    t.string   "descricao"
    t.binary   "foto"
    t.integer  "evento_tipo_id"
    t.integer  "dispositivo_id"
    t.boolean  "ativo",          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registros", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "via"
    t.float    "velocidade"
    t.datetime "data_hora"
    t.integer  "dispositivo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
