class CrPosts < ActiveRecord::Migration
  def change
    create_table :posts do |post|
      post.string :name
    end
  end
end
