class AddDeletedAtToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :deleted_at, :datetime
    add_index :portfolios, :deleted_at
  end
end
