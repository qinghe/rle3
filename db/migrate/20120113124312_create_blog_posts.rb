class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :blog_posts, :id => true do |t|
      t.string :title
      t.text :body
      t.boolean :draft
      t.datetime :published_at
      t.timestamps
    end

    add_index :blog_posts, :id

    create_table :blog_comments, :id => true do |t|
      t.integer :blog_post_id
      t.boolean :spam
      t.string :name
      t.string :email
      t.text :body
      t.string :state
      t.timestamps
    end

    add_index :blog_comments, :id

  end

  def self.down
    drop_table :blog_posts
    drop_table :blog_comments
  end
end
