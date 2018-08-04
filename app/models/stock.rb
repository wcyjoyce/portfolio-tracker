class Stock < ApplicationRecord
  belongs_to :portfolio
  validates :ticker, :shares, :added, :price, presence: true

  def name(ticker)
    StockQuote::Stock.quote(ticker).company_name
  end

  def current_price(ticker)
    StockQuote::Stock.quote(ticker).latest_price
  end

  def total_cost
    total_cost = shares * price
  end

  def market_value
    market_value = shares * current_price(ticker)
  end

  def profit_amount
    profit_amount = market_value - total_cost
  end

  def profit_pct
    profit_amount / total_cost * 100
  end

  def ytd(ticker)
    StockQuote::Stock.quote(ticker).ytd_change
  end
end
