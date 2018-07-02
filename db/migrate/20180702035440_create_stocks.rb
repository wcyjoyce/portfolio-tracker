class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :ticker
      t.decimal :price
      t.string :country
      t.string :sector
      t.decimal :ytd
      t.decimal :return
      t.string :market
      t.string :market_status
      t.decimal :open
      t.decimal :close
      t.decimal :high
      t.decimal :low
      t.decimal :high_52
      t.decimal :low_52
      t.decimal :dividend
      t.decimal :earnings
      t.decimal :volatility
      t.decimal :pe_ratio
      t.timestamps
    end
  end
end
