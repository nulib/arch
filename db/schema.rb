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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160503000000) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,   null: false
    t.string   "user_type",     limit: 255
    t.string   "document_id",   limit: 255
    t.string   "title",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "document_type", limit: 255
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "checksum_audit_logs", force: :cascade do |t|
    t.string   "file_set_id",     limit: 255
    t.string   "file_id",         limit: 255
    t.string   "version",         limit: 255
    t.integer  "pass",            limit: 4
    t.string   "expected_result", limit: 255
    t.string   "actual_result",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checksum_audit_logs", ["file_set_id", "file_id"], name: "by_file_set_id_and_file_id", using: :btree

  create_table "content_blocks", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "value",        limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "external_key", limit: 255
  end

  create_table "domain_terms", force: :cascade do |t|
    t.string "model", limit: 255
    t.string "term",  limit: 255
  end

  add_index "domain_terms", ["model", "term"], name: "terms_by_model_and_term", using: :btree

  create_table "domain_terms_local_authorities", id: false, force: :cascade do |t|
    t.integer "domain_term_id",     limit: 4
    t.integer "local_authority_id", limit: 4
  end

  add_index "domain_terms_local_authorities", ["domain_term_id", "local_authority_id"], name: "dtla_by_ids2", using: :btree
  add_index "domain_terms_local_authorities", ["local_authority_id", "domain_term_id"], name: "dtla_by_ids1", using: :btree

  create_table "featured_works", force: :cascade do |t|
    t.integer  "order",           limit: 4,   default: 5
    t.string   "generic_work_id", limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "featured_works", ["generic_work_id"], name: "index_featured_works_on_generic_work_id", using: :btree
  add_index "featured_works", ["order"], name: "index_featured_works_on_order", using: :btree

  create_table "file_download_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer  "downloads",  limit: 4
    t.string   "file_id",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  add_index "file_download_stats", ["file_id"], name: "index_file_download_stats_on_file_id", using: :btree
  add_index "file_download_stats", ["user_id"], name: "index_file_download_stats_on_user_id", using: :btree

  create_table "file_view_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer  "views",      limit: 4
    t.string   "file_id",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  add_index "file_view_stats", ["file_id"], name: "index_file_view_stats_on_file_id", using: :btree
  add_index "file_view_stats", ["user_id"], name: "index_file_view_stats_on_user_id", using: :btree

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",   limit: 4,                   null: false
    t.string   "followable_type", limit: 255,                 null: false
    t.integer  "follower_id",     limit: 4,                   null: false
    t.string   "follower_type",   limit: 255,                 null: false
    t.boolean  "blocked",                     default: false, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "local_authorities", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "local_authority_entries", force: :cascade do |t|
    t.integer "local_authority_id", limit: 4
    t.string  "label",              limit: 255
    t.string  "uri",                limit: 255
  end

  add_index "local_authority_entries", ["local_authority_id", "label"], name: "entries_by_term_and_label", using: :btree
  add_index "local_authority_entries", ["local_authority_id", "uri"], name: "entries_by_term_and_uri", using: :btree

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id",   limit: 4
    t.string  "unsubscriber_type", limit: 255
    t.integer "conversation_id",   limit: 4
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    limit: 255, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type",                 limit: 255
    t.text     "body",                 limit: 65535
    t.string   "subject",              limit: 255,   default: ""
    t.integer  "sender_id",            limit: 4
    t.string   "sender_type",          limit: 255
    t.integer  "conversation_id",      limit: 4
    t.boolean  "draft",                              default: false
    t.string   "notification_code",    limit: 255
    t.integer  "notified_object_id",   limit: 4
    t.string   "notified_object_type", limit: 255
    t.string   "attachment",           limit: 255
    t.datetime "updated_at",                                         null: false
    t.datetime "created_at",                                         null: false
    t.boolean  "global",                             default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id",     limit: 4
    t.string   "receiver_type",   limit: 255
    t.integer  "notification_id", limit: 4,                   null: false
    t.boolean  "is_read",                     default: false
    t.boolean  "trashed",                     default: false
    t.boolean  "deleted",                     default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "proxy_deposit_requests", force: :cascade do |t|
    t.string   "generic_work_id",   limit: 255,                       null: false
    t.integer  "sending_user_id",   limit: 4,                         null: false
    t.integer  "receiving_user_id", limit: 4,                         null: false
    t.datetime "fulfillment_date"
    t.string   "status",            limit: 255,   default: "pending", null: false
    t.text     "sender_comment",    limit: 65535
    t.text     "receiver_comment",  limit: 65535
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "proxy_deposit_requests", ["receiving_user_id"], name: "index_proxy_deposit_requests_on_receiving_user_id", using: :btree
  add_index "proxy_deposit_requests", ["sending_user_id"], name: "index_proxy_deposit_requests_on_sending_user_id", using: :btree

  create_table "proxy_deposit_rights", force: :cascade do |t|
    t.integer  "grantor_id", limit: 4
    t.integer  "grantee_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "proxy_deposit_rights", ["grantee_id"], name: "index_proxy_deposit_rights_on_grantee_id", using: :btree
  add_index "proxy_deposit_rights", ["grantor_id"], name: "index_proxy_deposit_rights_on_grantor_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", using: :btree
  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", using: :btree

  create_table "searches", force: :cascade do |t|
    t.text     "query_params", limit: 65535
    t.integer  "user_id",      limit: 4
    t.string   "user_type",    limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "single_use_links", force: :cascade do |t|
    t.string   "downloadKey", limit: 255
    t.string   "path",        limit: 255
    t.string   "itemId",      limit: 255
    t.datetime "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_local_authority_entries", force: :cascade do |t|
    t.string "label",      limit: 255
    t.string "lowerLabel", limit: 255
    t.string "url",        limit: 255
  end

  add_index "subject_local_authority_entries", ["lowerLabel"], name: "entries_by_lower_label", using: :btree

  create_table "tinymce_assets", force: :cascade do |t|
    t.string   "file",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "trophies", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.string   "generic_work_id", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string   "file",         limit: 255
    t.integer  "user_id",      limit: 4
    t.string   "file_set_uri", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "uploaded_files", ["file_set_uri"], name: "index_uploaded_files_on_file_set_uri", using: :btree
  add_index "uploaded_files", ["user_id"], name: "index_uploaded_files_on_user_id", using: :btree

  create_table "user_stats", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.datetime "date"
    t.integer  "file_views",     limit: 4
    t.integer  "file_downloads", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "work_views",     limit: 4
  end

  add_index "user_stats", ["user_id"], name: "index_user_stats_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",               limit: 255,   default: "",    null: false
    t.string   "encrypted_password",  limit: 255,   default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "guest",                             default: false
    t.string   "facebook_handle",     limit: 255
    t.string   "twitter_handle",      limit: 255
    t.string   "googleplus_handle",   limit: 255
    t.string   "display_name",        limit: 255
    t.string   "address",             limit: 255
    t.string   "admin_area",          limit: 255
    t.string   "department",          limit: 255
    t.string   "title",               limit: 255
    t.string   "office",              limit: 255
    t.string   "chat_id",             limit: 255
    t.string   "website",             limit: 255
    t.string   "affiliation",         limit: 255
    t.string   "telephone",           limit: 255
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.text     "group_list",          limit: 65535
    t.datetime "groups_last_update"
    t.string   "linkedin_handle",     limit: 255
    t.string   "orcid",               limit: 255
    t.string   "username",            limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "version_committers", force: :cascade do |t|
    t.string   "obj_id",          limit: 255
    t.string   "datastream_id",   limit: 255
    t.string   "version_id",      limit: 255
    t.string   "committer_login", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_view_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer  "work_views", limit: 4
    t.string   "work_id",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  add_index "work_view_stats", ["user_id"], name: "index_work_view_stats_on_user_id", using: :btree
  add_index "work_view_stats", ["work_id"], name: "index_work_view_stats_on_work_id", using: :btree

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "uploaded_files", "users"
end
