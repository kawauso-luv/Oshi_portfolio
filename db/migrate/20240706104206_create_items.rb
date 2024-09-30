class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.integer :user_id
      t.string :name
      t.string :image_url
      t.integer :price
      t.string :category
      t.string :genre
      t.timestamps null: false
    end  
  end
end