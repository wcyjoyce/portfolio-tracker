class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :ticker
      t.integer :shares
      t.date :added
      t.decimal :price
      t.references :portfolio, foreign_key: true
    end
  end
end