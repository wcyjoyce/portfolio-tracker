class Stock < ApplicationRecord
  belongs_to :portfolio
  validates :ticker, :shares, :added, :price, presence: true

  def name(ticker)
    StockQuote::Stock.company(ticker).company_name
  end

  # only used for original holdings table
  def sector(ticker)
    StockQuote::Stock.company(ticker).sector
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
    StockQuote::Stock.quote(ticker).ytd_change * 100
  end

  def market_status(ticker)
    status = StockQuote::Stock.quote(ticker).latest_source
    status == "Close" ? "closed" : "open"
  end
end
