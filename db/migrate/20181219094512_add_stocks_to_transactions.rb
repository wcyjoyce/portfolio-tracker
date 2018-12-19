class AddStocksToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :stock, foreign_key: true
  end
end
