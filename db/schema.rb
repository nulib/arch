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

ActiveRecord::Schema.define(version: 20170324151852) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.string   "user_type"
    t.string   "document_id"
    t.string   "document_type"
    t.string   "title"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "bookmarks", ["document_id"], name: "index_bookmarks_on_document_id"
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id"

  create_table "checksum_audit_logs", force: :cascade do |t|
    t.string   "file_set_id"
    t.string   "file_id"
    t.string   "version"
    t.integer  "pass"
    t.string   "expected_result"
    t.string   "actual_result"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "checksum_audit_logs", ["file_set_id", "file_id"], name: "by_file_set_id_and_file_id"

  create_table "content_blocks", force: :cascade do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "external_key"
  end

  create_table "curation_concerns_operations", force: :cascade do |t|
    t.string   "status"
    t.string   "operation_type"
    t.string   "job_class"
    t.string   "job_id"
    t.string   "type"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "lft",                        null: false
    t.integer  "rgt",                        null: false
    t.integer  "depth",          default: 0, null: false
    t.integer  "children_count", default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "curation_concerns_operations", ["lft"], name: "index_curation_concerns_operations_on_lft"
  add_index "curation_concerns_operations", ["parent_id"], name: "index_curation_concerns_operations_on_parent_id"
  add_index "curation_concerns_operations", ["rgt"], name: "index_curation_concerns_operations_on_rgt"
  add_index "curation_concerns_operations", ["user_id"], name: "index_curation_concerns_operations_on_user_id"

  create_table "domain_terms", force: :cascade do |t|
    t.string "model"
    t.string "term"
  end

  add_index "domain_terms", ["model", "term"], name: "terms_by_model_and_term"

  create_table "domain_terms_local_authorities", id: false, force: :cascade do |t|
    t.integer "domain_term_id"
    t.integer "local_authority_id"
  end

  add_index "domain_terms_local_authorities", ["domain_term_id", "local_authority_id"], name: "dtla_by_ids2"
  add_index "domain_terms_local_authorities", ["local_authority_id", "domain_term_id"], name: "dtla_by_ids1"

  create_table "featured_works", force: :cascade do |t|
    t.integer  "order",      default: 5
    t.string   "work_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "featured_works", ["order"], name: "index_featured_works_on_order"
  add_index "featured_works", ["work_id"], name: "index_featured_works_on_work_id"

  create_table "file_download_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer  "downloads"
    t.string   "file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "file_download_stats", ["file_id"], name: "index_file_download_stats_on_file_id"
  add_index "file_download_stats", ["user_id"], name: "index_file_download_stats_on_user_id"

  create_table "file_view_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer  "views"
    t.string   "file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "file_view_stats", ["file_id"], name: "index_file_view_stats_on_file_id"
  add_index "file_view_stats", ["user_id"], name: "index_file_view_stats_on_user_id"

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows"

  create_table "local_authorities", force: :cascade do |t|
    t.string "name"
  end

  create_table "local_authority_entries", force: :cascade do |t|
    t.integer "local_authority_id"
    t.string  "label"
    t.string  "uri"
  end

  add_index "local_authority_entries", ["local_authority_id", "label"], name: "entries_by_term_and_label"
  add_index "local_authority_entries", ["local_authority_id", "uri"], name: "entries_by_term_and_uri"

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type"

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"

  create_table "permission_template_accesses", force: :cascade do |t|
    t.integer  "permission_template_id"
    t.string   "agent_type"
    t.string   "agent_id"
    t.string   "access"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permission_templates", force: :cascade do |t|
    t.string   "admin_set_id"
    t.string   "visibility"
    t.string   "workflow_name",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "release_date"
    t.string   "release_period"
  end

  add_index "permission_templates", ["admin_set_id"], name: "index_permission_templates_on_admin_set_id"

  create_table "proxy_deposit_requests", force: :cascade do |t|
    t.string   "work_id",                               null: false
    t.integer  "sending_user_id",                       null: false
    t.integer  "receiving_user_id",                     null: false
    t.datetime "fulfillment_date"
    t.string   "status",            default: "pending", null: false
    t.text     "sender_comment"
    t.text     "receiver_comment"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "proxy_deposit_requests", ["receiving_user_id"], name: "index_proxy_deposit_requests_on_receiving_user_id"
  add_index "proxy_deposit_requests", ["sending_user_id"], name: "index_proxy_deposit_requests_on_sending_user_id"

  create_table "proxy_deposit_rights", force: :cascade do |t|
    t.integer  "grantor_id"
    t.integer  "grantee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "proxy_deposit_rights", ["grantee_id"], name: "index_proxy_deposit_rights_on_grantee_id"
  add_index "proxy_deposit_rights", ["grantor_id"], name: "index_proxy_deposit_rights_on_grantor_id"

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id"
  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id"

  create_table "searches", force: :cascade do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id"

  create_table "single_use_links", force: :cascade do |t|
    t.string   "downloadKey"
    t.string   "path"
    t.string   "itemId"
    t.datetime "expires"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sipity_agents", force: :cascade do |t|
    t.string   "proxy_for_id",   null: false
    t.string   "proxy_for_type", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "sipity_agents", ["proxy_for_id", "proxy_for_type"], name: "sipity_agents_proxy_for", unique: true

  create_table "sipity_comments", force: :cascade do |t|
    t.integer  "entity_id",  null: false
    t.integer  "agent_id",   null: false
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sipity_comments", ["agent_id"], name: "index_sipity_comments_on_agent_id"
  add_index "sipity_comments", ["created_at"], name: "index_sipity_comments_on_created_at"
  add_index "sipity_comments", ["entity_id"], name: "index_sipity_comments_on_entity_id"

  create_table "sipity_entities", force: :cascade do |t|
    t.string   "proxy_for_global_id", null: false
    t.integer  "workflow_id",         null: false
    t.integer  "workflow_state_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "sipity_entities", ["proxy_for_global_id"], name: "sipity_entities_proxy_for_global_id", unique: true
  add_index "sipity_entities", ["workflow_id"], name: "index_sipity_entities_on_workflow_id"
  add_index "sipity_entities", ["workflow_state_id"], name: "index_sipity_entities_on_workflow_state_id"

  create_table "sipity_entity_specific_responsibilities", force: :cascade do |t|
    t.integer  "workflow_role_id", null: false
    t.string   "entity_id",        null: false
    t.integer  "agent_id",         null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "sipity_entity_specific_responsibilities", ["agent_id"], name: "sipity_entity_specific_responsibilities_agent"
  add_index "sipity_entity_specific_responsibilities", ["entity_id"], name: "sipity_entity_specific_responsibilities_entity"
  add_index "sipity_entity_specific_responsibilities", ["workflow_role_id", "entity_id", "agent_id"], name: "sipity_entity_specific_responsibilities_aggregate", unique: true
  add_index "sipity_entity_specific_responsibilities", ["workflow_role_id"], name: "sipity_entity_specific_responsibilities_role"

  create_table "sipity_notifiable_contexts", force: :cascade do |t|
    t.integer  "scope_for_notification_id",   null: false
    t.string   "scope_for_notification_type", null: false
    t.string   "reason_for_notification",     null: false
    t.integer  "notification_id",             null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "sipity_notifiable_contexts", ["notification_id"], name: "sipity_notifiable_contexts_notification_id"
  add_index "sipity_notifiable_contexts", ["scope_for_notification_id", "scope_for_notification_type", "reason_for_notification", "notification_id"], name: "sipity_notifiable_contexts_concern_surrogate", unique: true
  add_index "sipity_notifiable_contexts", ["scope_for_notification_id", "scope_for_notification_type", "reason_for_notification"], name: "sipity_notifiable_contexts_concern_context"
  add_index "sipity_notifiable_contexts", ["scope_for_notification_id", "scope_for_notification_type"], name: "sipity_notifiable_contexts_concern"

  create_table "sipity_notification_recipients", force: :cascade do |t|
    t.integer  "notification_id",    null: false
    t.integer  "role_id",            null: false
    t.string   "recipient_strategy", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "sipity_notification_recipients", ["notification_id", "role_id", "recipient_strategy"], name: "sipity_notifications_recipients_surrogate"
  add_index "sipity_notification_recipients", ["notification_id"], name: "sipity_notification_recipients_notification"
  add_index "sipity_notification_recipients", ["recipient_strategy"], name: "sipity_notification_recipients_recipient_strategy"
  add_index "sipity_notification_recipients", ["role_id"], name: "sipity_notification_recipients_role"

  create_table "sipity_notifications", force: :cascade do |t|
    t.string   "name",              null: false
    t.string   "notification_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "sipity_notifications", ["name"], name: "index_sipity_notifications_on_name", unique: true
  add_index "sipity_notifications", ["notification_type"], name: "index_sipity_notifications_on_notification_type"

  create_table "sipity_roles", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sipity_roles", ["name"], name: "index_sipity_roles_on_name", unique: true

  create_table "sipity_workflow_actions", force: :cascade do |t|
    t.integer  "workflow_id",                 null: false
    t.integer  "resulting_workflow_state_id"
    t.string   "name",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "sipity_workflow_actions", ["resulting_workflow_state_id"], name: "sipity_workflow_actions_resulting_workflow_state"
  add_index "sipity_workflow_actions", ["workflow_id", "name"], name: "sipity_workflow_actions_aggregate", unique: true
  add_index "sipity_workflow_actions", ["workflow_id"], name: "sipity_workflow_actions_workflow"

  create_table "sipity_workflow_methods", force: :cascade do |t|
    t.string   "service_name",       null: false
    t.integer  "weight",             null: false
    t.integer  "workflow_action_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "sipity_workflow_methods", ["workflow_action_id"], name: "index_sipity_workflow_methods_on_workflow_action_id"

  create_table "sipity_workflow_responsibilities", force: :cascade do |t|
    t.integer  "agent_id",         null: false
    t.integer  "workflow_role_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "sipity_workflow_responsibilities", ["agent_id", "workflow_role_id"], name: "sipity_workflow_responsibilities_aggregate", unique: true

  create_table "sipity_workflow_roles", force: :cascade do |t|
    t.integer  "workflow_id", null: false
    t.integer  "role_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sipity_workflow_roles", ["workflow_id", "role_id"], name: "sipity_workflow_roles_aggregate", unique: true

  create_table "sipity_workflow_state_action_permissions", force: :cascade do |t|
    t.integer  "workflow_role_id",         null: false
    t.integer  "workflow_state_action_id", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sipity_workflow_state_action_permissions", ["workflow_role_id", "workflow_state_action_id"], name: "sipity_workflow_state_action_permissions_aggregate", unique: true

  create_table "sipity_workflow_state_actions", force: :cascade do |t|
    t.integer  "originating_workflow_state_id", null: false
    t.integer  "workflow_action_id",            null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "sipity_workflow_state_actions", ["originating_workflow_state_id", "workflow_action_id"], name: "sipity_workflow_state_actions_aggregate", unique: true

  create_table "sipity_workflow_states", force: :cascade do |t|
    t.integer  "workflow_id", null: false
    t.string   "name",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sipity_workflow_states", ["name"], name: "index_sipity_workflow_states_on_name"
  add_index "sipity_workflow_states", ["workflow_id", "name"], name: "sipity_type_state_aggregate", unique: true

  create_table "sipity_workflows", force: :cascade do |t|
    t.string   "name",                null: false
    t.string   "label"
    t.text     "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.boolean  "allows_access_grant"
  end

  add_index "sipity_workflows", ["name"], name: "index_sipity_workflows_on_name", unique: true

  create_table "subject_local_authority_entries", force: :cascade do |t|
    t.string "label"
    t.string "lowerLabel"
    t.string "url"
  end

  add_index "subject_local_authority_entries", ["lowerLabel"], name: "entries_by_lower_label"

  create_table "sufia_features", force: :cascade do |t|
    t.string   "key",                        null: false
    t.boolean  "enabled",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "tinymce_assets", force: :cascade do |t|
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trophies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string   "file"
    t.integer  "user_id"
    t.string   "file_set_uri"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "uploaded_files", ["file_set_uri"], name: "index_uploaded_files_on_file_set_uri"
  add_index "uploaded_files", ["user_id"], name: "index_uploaded_files_on_user_id"

  create_table "user_stats", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "date"
    t.integer  "file_views"
    t.integer  "file_downloads"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "work_views"
  end

  add_index "user_stats", ["user_id"], name: "index_user_stats_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: "",    null: false
    t.string   "encrypted_password",  default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "guest",               default: false
    t.string   "facebook_handle"
    t.string   "twitter_handle"
    t.string   "googleplus_handle"
    t.string   "display_name"
    t.string   "address"
    t.string   "admin_area"
    t.string   "department"
    t.string   "title"
    t.string   "office"
    t.string   "chat_id"
    t.string   "website"
    t.string   "affiliation"
    t.string   "telephone"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "linkedin_handle"
    t.string   "orcid"
    t.string   "username"
    t.string   "arkivo_token"
    t.string   "arkivo_subscription"
    t.binary   "zotero_token"
    t.string   "zotero_userid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username"

  create_table "version_committers", force: :cascade do |t|
    t.string   "obj_id"
    t.string   "datastream_id"
    t.string   "version_id"
    t.string   "committer_login"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "work_view_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer  "work_views"
    t.string   "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "work_view_stats", ["user_id"], name: "index_work_view_stats_on_user_id"
  add_index "work_view_stats", ["work_id"], name: "index_work_view_stats_on_work_id"

end
