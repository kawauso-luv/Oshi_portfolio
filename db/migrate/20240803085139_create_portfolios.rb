class CreatePortfolios < ActiveRecord::Migration[6.1]
  def change
    create_table :portfolios do |t|
      t.integer :user_id
      t.string :genre
      t.integer :total_price
      t.integer :genre_price
      t.integer :genre_percent
      t.string :color
    end  
  end
end
