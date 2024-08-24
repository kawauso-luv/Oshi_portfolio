class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :image_url
      t.string :user_name
      t.text :genre
      t.text :content
      t.integer :like
      t.timestamps null: false
    end  
  end
end
