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

ActiveRecord::Schema.define(:version => 20120113124312) do

  create_table "assignments", :id => false, :force => true do |t|
    t.integer  "website_id",   :default => 0,  :null => false
    t.integer  "blog_post_id", :default => 0,  :null => false
    t.integer  "menu_id",      :default => 0,  :null => false
    t.integer  "position"
    t.string   "name",         :default => "", :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "blog_comments", :force => true do |t|
    t.integer  "blog_post_id"
    t.boolean  "spam"
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.string   "state"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "blog_comments", ["id"], :name => "index_blog_comments_on_id"

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "is_published"
    t.datetime "published_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "blog_posts", ["id"], :name => "index_blog_posts_on_id"

  create_table "editors", :force => true do |t|
    t.string   "slug",       :limit => 200, :default => "", :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "html_attributes", :force => true do |t|
    t.string  "title",                      :default => "",    :null => false
    t.string  "slug",                       :default => "",    :null => false
    t.string  "pvalues",                    :default => "",    :null => false
    t.string  "pvalues_desc",               :default => "",    :null => false
    t.string  "punits",                     :default => "",    :null => false
    t.boolean "neg_ok",                     :default => false, :null => false
    t.integer "default_value", :limit => 2, :default => 0,     :null => false
    t.string  "pvspecial",     :limit => 7, :default => "",    :null => false
  end

  add_index "html_attributes", ["slug"], :name => "index_html_attributes_on_slug", :unique => true

  create_table "menu_levels", :force => true do |t|
    t.integer "menu_id",          :limit => 3, :default => 0, :null => false
    t.integer "level",            :limit => 2, :default => 0, :null => false
    t.integer "theme_id",         :limit => 2, :default => 0, :null => false
    t.integer "detail_theme_id",  :limit => 2, :default => 0, :null => false
    t.integer "ptheme_id",                     :default => 0, :null => false
    t.integer "pdetail_theme_id",              :default => 0, :null => false
  end

  create_table "menus", :force => true do |t|
    t.integer  "website_id",       :default => 0,    :null => false
    t.string   "title"
    t.string   "slug"
    t.integer  "root_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.boolean  "clickable",        :default => true
    t.boolean  "is_enabled",       :default => true
    t.boolean  "inheritance",      :default => true
    t.integer  "theme_id",         :default => 0,    :null => false
    t.integer  "detail_theme_id",  :default => 0,    :null => false
    t.integer  "ptheme_id",        :default => 0,    :null => false
    t.integer  "pdetail_theme_id", :default => 0,    :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "page_layouts", :force => true do |t|
    t.integer  "website_id",        :limit => 3,   :default => 0
    t.integer  "root_id",           :limit => 3
    t.integer  "parent_id",         :limit => 3
    t.integer  "lft",               :limit => 2,   :default => 0,     :null => false
    t.integer  "rgt",               :limit => 2,   :default => 0,     :null => false
    t.string   "title",             :limit => 200, :default => "",    :null => false
    t.string   "slug",              :limit => 200, :default => "",    :null => false
    t.integer  "section_id",        :limit => 3,   :default => 0
    t.integer  "section_instance",  :limit => 2,   :default => 0,     :null => false
    t.string   "section_context",   :limit => 32,  :default => "",    :null => false
    t.string   "data_source",       :limit => 32,  :default => "",    :null => false
    t.string   "data_filter",       :limit => 32,  :default => "",    :null => false
    t.boolean  "is_enabled",                       :default => true,  :null => false
    t.integer  "copy_from_root_id",                :default => 0,     :null => false
    t.boolean  "is_full_html",                     :default => false, :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  create_table "param_categories", :force => true do |t|
    t.integer  "editor_id",  :limit => 3,   :default => 0,    :null => false
    t.integer  "position",   :limit => 3,   :default => 0
    t.string   "slug",       :limit => 200, :default => "",   :null => false
    t.boolean  "is_enabled",                :default => true, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "param_values", :force => true do |t|
    t.integer  "page_layout_root_id", :limit => 2, :default => 0, :null => false
    t.integer  "page_layout_id",      :limit => 2, :default => 0, :null => false
    t.integer  "section_param_id",    :limit => 2, :default => 0, :null => false
    t.integer  "theme_id",            :limit => 2, :default => 0, :null => false
    t.string   "pvalue"
    t.string   "unset"
    t.string   "computed_pvalue"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "section_params", :force => true do |t|
    t.integer  "section_root_id"
    t.integer  "section_id"
    t.integer  "section_piece_param_id"
    t.string   "default_value"
    t.boolean  "is_enabled",             :default => true
    t.string   "disabled_ha_ids",        :default => "",   :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "section_piece_params", :force => true do |t|
    t.integer "section_piece_id",   :limit => 2,    :default => 0,    :null => false
    t.integer "editor_id",          :limit => 2,    :default => 0,    :null => false
    t.integer "param_category_id",  :limit => 2,    :default => 0,    :null => false
    t.integer "position",           :limit => 2,    :default => 0,    :null => false
    t.string  "pclass"
    t.string  "class_name",                         :default => "",   :null => false
    t.string  "html_attribute_ids", :limit => 1000, :default => "",   :null => false
    t.string  "param_conditions",   :limit => 1000
    t.boolean "is_editable",                        :default => true
  end

  create_table "section_pieces", :force => true do |t|
    t.string   "title",         :limit => 100,                      :null => false
    t.string   "slug",          :limit => 100,                      :null => false
    t.string   "html",          :limit => 12000, :default => "",    :null => false
    t.string   "css",           :limit => 8000,  :default => "",    :null => false
    t.string   "js",            :limit => 60,    :default => "",    :null => false
    t.boolean  "is_root",                        :default => false, :null => false
    t.boolean  "is_container",                   :default => false, :null => false
    t.boolean  "is_selectable",                  :default => false, :null => false
    t.string   "resources",     :limit => 10,    :default => "",    :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "section_pieces", ["slug"], :name => "index_section_pieces_on_slug", :unique => true

  create_table "section_texts", :force => true do |t|
    t.string   "lang"
    t.string   "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sections", :force => true do |t|
    t.integer "website_id",               :limit => 3
    t.integer "root_id",                  :limit => 3
    t.integer "parent_id",                :limit => 3
    t.integer "lft",                      :limit => 2,   :default => 0,    :null => false
    t.integer "rgt",                      :limit => 2,   :default => 0,    :null => false
    t.string  "title",                    :limit => 64,  :default => "",   :null => false
    t.string  "slug",                     :limit => 64,  :default => "",   :null => false
    t.integer "section_piece_id",         :limit => 3,   :default => 0
    t.integer "section_piece_instance",   :limit => 2,   :default => 0
    t.boolean "is_enabled",                              :default => true, :null => false
    t.string  "global_events",            :limit => 200, :default => "",   :null => false
    t.string  "subscribed_global_events", :limit => 200, :default => "",   :null => false
  end

  create_table "template_files", :force => true do |t|
    t.integer  "theme_id"
    t.datetime "created_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "template_themes", :force => true do |t|
    t.integer "website_id",                          :default => 0
    t.integer "page_layout_root_id",                 :default => 0,  :null => false
    t.string  "title",                 :limit => 64, :default => "", :null => false
    t.string  "slug",                  :limit => 64, :default => "", :null => false
    t.string  "assigned_resource_ids",               :default => "", :null => false
  end

  create_table "websites", :force => true do |t|
    t.string   "title",            :limit => 24,                :null => false
    t.string   "slug",             :limit => 24,                :null => false
    t.string   "url"
    t.integer  "index_page",                     :default => 0, :null => false
    t.integer  "list_template",                  :default => 0, :null => false
    t.integer  "detail_template",                :default => 0, :null => false
    t.integer  "plist_template",                 :default => 0, :null => false
    t.integer  "pdetail_template",               :default => 0, :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "websites", ["slug"], :name => "index_websites_on_slug", :unique => true

end
