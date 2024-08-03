class CreatePortfolios < ActiveRecord::Migration[6.1]
  def change
    create_table :portfolios do |t|
      t.integer :user
      t.string :genre
      t.integer :total_price
      t.integer :genre_price
      t.integer :item_id
      t.integer :post_id
    end  
  end
end
