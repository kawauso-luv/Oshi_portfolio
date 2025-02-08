class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :image_url
      t.string :user_name
      t.text :genre
      t.text :content
      t.integer :like
      t.timestamps null: false
    end  
  end
end
