class RemoveNameFromTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :name, :string
  end
end
