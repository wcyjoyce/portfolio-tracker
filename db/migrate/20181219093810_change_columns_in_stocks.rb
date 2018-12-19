class ChangeColumnsInStocks < ActiveRecord::Migration[5.1]
  def change
    remove_column :stocks, :name
    remove_column :stocks, :shares
    remove_column :stocks, :added
    remove_column :stocks, :price
  end
end
