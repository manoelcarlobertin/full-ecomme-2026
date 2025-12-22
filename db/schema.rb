# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_08_172551) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.string "number"
    t.string "state"
    t.string "street"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "zipcode"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.decimal "discount_value", precision: 5, scale: 2
    t.datetime "due_date"
    t.integer "max_use"
    t.string "name"
    t.integer "status"
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "developer"
    t.integer "mode"
    t.datetime "release_date"
    t.integer "system_requirement_id", null: false
    t.datetime "updated_at", null: false
    t.index ["system_requirement_id"], name: "index_games_on_system_requirement_id"
  end

  create_table "juno_charges", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.string "billet_url"
    t.string "code"
    t.datetime "created_at", null: false
    t.string "key"
    t.string "number"
    t.integer "order_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_juno_charges_on_order_id"
  end

  create_table "juno_credit_card_payments", force: :cascade do |t|
    t.integer "charge_id", null: false
    t.datetime "created_at", null: false
    t.string "status"
    t.string "unique_id"
    t.datetime "updated_at", null: false
    t.index ["charge_id"], name: "index_juno_credit_card_payments_on_charge_id"
  end

  create_table "juno_credit_cards", force: :cascade do |t|
    t.string "billet_url"
    t.string "code"
    t.string "cpf_cnpj"
    t.datetime "created_at", null: false
    t.string "email"
    t.integer "expiration_month"
    t.integer "expiration_year"
    t.string "holder_name"
    t.string "key"
    t.string "number", limit: 4
    t.datetime "updated_at", null: false
  end

  create_table "licenses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "game_id", null: false
    t.string "key"
    t.integer "order_item_id"
    t.integer "platform"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["game_id"], name: "index_licenses_on_game_id"
    t.index ["order_item_id"], name: "index_licenses_on_order_item_id"
    t.index ["user_id"], name: "index_licenses_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "order_id", null: false
    t.decimal "payed_price", precision: 10, scale: 2
    t.integer "product_id", null: false
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "address_id"
    t.string "card_hash"
    t.integer "coupon_id"
    t.datetime "created_at", null: false
    t.string "document"
    t.integer "installments", default: 1
    t.integer "payment_type", default: 0
    t.integer "status"
    t.decimal "subtotal", precision: 14, scale: 2
    t.decimal "total_amount", precision: 14, scale: 2
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["coupon_id"], name: "index_orders_on_coupon_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "featured", default: false
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.integer "productable_id"
    t.string "productable_type"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["productable_type", "productable_id"], name: "index_products_on_productable"
  end

  create_table "system_requirements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "memory"
    t.string "name"
    t.string "operational_system"
    t.string "processor"
    t.string "storage"
    t.datetime "updated_at", null: false
    t.string "video_board"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "document"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.integer "profile", default: 1
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_users_on_document"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wish_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["product_id"], name: "index_wish_items_on_product_id"
    t.index ["user_id"], name: "index_wish_items_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "games", "system_requirements"
  add_foreign_key "juno_charges", "orders"
  add_foreign_key "juno_credit_card_payments", "juno_charges", column: "charge_id"
  add_foreign_key "licenses", "games"
  add_foreign_key "licenses", "order_items"
  add_foreign_key "licenses", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "coupons"
  add_foreign_key "orders", "users"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "wish_items", "products"
  add_foreign_key "wish_items", "users"
end
