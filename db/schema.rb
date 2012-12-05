# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121031000610) do

  create_table "deals", :force => true do |t|
    t.integer  "pipedrive_id"
    t.integer  "public_id"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "user_email"
    t.string   "person_name"
    t.string   "org_name"
    t.string   "title"
    t.decimal  "value"
    t.string   "currency"
    t.integer  "products_count"
    t.string   "feira_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "unique_id"
    t.integer  "pipe_deal_id"
    t.integer  "order_nr"
    t.integer  "product_id"
    t.decimal  "item_price"
    t.decimal  "sum"
    t.string   "currency"
    t.string   "name"
    t.integer  "quantity"
    t.string   "product_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "deal_id"
  end

  create_table "organizations", :force => true do |t|
    t.integer  "pipedrive_id"
    t.integer  "my_finance_id"
    t.string   "name"
    t.string   "segmento"
    t.string   "razao_social"
    t.integer  "fisica_juridica"
    t.string   "cpf_cnpj"
    t.string   "url"
    t.string   "email"
    t.datetime "update_time"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
