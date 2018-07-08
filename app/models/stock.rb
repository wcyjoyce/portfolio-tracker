class Stock < ApplicationRecord
  belongs_to :portfolio
  validates :ticker, :shares, :added, :price, presence: true

  def name(ticker)
    StockQuote::Stock.quote(ticker).company_name
  end
end
