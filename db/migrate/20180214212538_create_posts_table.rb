class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
          t.string :title
          t.string :content
          t.string :catagory
          t.integer :user_id
      end
  end
end
