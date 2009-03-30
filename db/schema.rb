# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 15) do

  create_table "active_sources", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uri",        :null => false
    t.string   "type"
  end

  add_index "active_sources", ["uri"], :name => "index_active_sources_on_uri", :unique => true

  create_table "data_records", :force => true do |t|
    t.string  "type"
    t.string  "location",                :null => false
    t.string  "mime"
    t.integer "source_id", :limit => 10, :null => false
  end

  add_index "data_records", ["source_id"], :name => "index_data_records_on_source_id"

  create_table "globalize_countries", :force => true do |t|
    t.string "code",                   :limit => 2
    t.string "english_name"
    t.string "date_format"
    t.string "currency_format"
    t.string "currency_code",          :limit => 3
    t.string "thousands_sep",          :limit => 2
    t.string "decimal_sep",            :limit => 2
    t.string "currency_decimal_sep",   :limit => 2
    t.string "number_grouping_scheme"
  end

  add_index "globalize_countries", ["code"], :name => "index_globalize_countries_on_code"

  create_table "globalize_languages", :force => true do |t|
    t.string  "iso_639_1",             :limit => 2
    t.string  "iso_639_2",             :limit => 3
    t.string  "iso_639_3",             :limit => 3
    t.string  "rfc_3066"
    t.string  "english_name"
    t.string  "english_name_locale"
    t.string  "english_name_modifier"
    t.string  "native_name"
    t.string  "native_name_locale"
    t.string  "native_name_modifier"
    t.boolean "macro_language"
    t.string  "direction"
    t.string  "pluralization"
    t.string  "scope",                 :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "index_globalize_languages_on_iso_639_1"
  add_index "globalize_languages", ["iso_639_2"], :name => "index_globalize_languages_on_iso_639_2"
  add_index "globalize_languages", ["iso_639_3"], :name => "index_globalize_languages_on_iso_639_3"
  add_index "globalize_languages", ["rfc_3066"], :name => "index_globalize_languages_on_rfc_3066"

  create_table "globalize_translations", :force => true do |t|
    t.string  "type"
    t.string  "tr_key"
    t.string  "table_name"
    t.integer "item_id",             :limit => 10
    t.string  "facet"
    t.boolean "built_in",                          :default => true
    t.integer "language_id",         :limit => 10
    t.integer "pluralization_index", :limit => 10
    t.text    "text"
    t.string  "namespace"
  end

  add_index "globalize_translations", ["tr_key", "language_id"], :name => "index_globalize_translations_on_tr_key_and_language_id"
  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued",     :limit => 10
    t.integer "lifetime",   :limit => 10
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :limit => 10, :null => false
    t.string  "server_url"
    t.string  "salt",                     :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :limit => 10
    t.integer "user_id", :limit => 10
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "semantic_properties", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "value",      :null => false
  end

  create_table "semantic_relations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "object_id",     :limit => 10, :null => false
    t.string   "object_type",                 :null => false
    t.integer  "subject_id",    :limit => 10, :null => false
    t.string   "predicate_uri",               :null => false
  end

  add_index "semantic_relations", ["predicate_uri"], :name => "index_semantic_relations_on_predicate_uri"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "open_id"
  end

  create_table "workflows", :force => true do |t|
    t.string  "state",                   :null => false
    t.string  "arguments",               :null => false
    t.string  "type"
    t.integer "source_id", :limit => 10, :null => false
  end

  add_index "workflows", ["source_id"], :name => "index_workflows_on_source_id", :unique => true

end
