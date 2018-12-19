class RemovePortfolioFromStocks < ActiveRecord::Migration[5.1]
  def change
    remove_reference :stocks, :portfolio, foreign_key: true
  end
end
