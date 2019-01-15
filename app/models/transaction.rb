class Transaction < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock
  validates :ticker, :shares, :added, :price, presence: true
  validate :not_in_future, :weekday
  acts_as_paranoid

  def not_in_future
    errors.add(:added, "Your transaction cannot be in the future") if added.present? && added > Date.today
  end

  def weekday
    errors.add(:added, "Trading is closed on weekends.") unless added.on_weekday?
  end

  def self.historical(stock, date)
    historical_price_url = "https://api.iextrading.com/1.0/stock/#{stock}/chart/date/#{date}"
    historical_price = JSON.parse(open(historical_price_url).read)
    historical_price.detect { |historical| historical["marketClose"] }
  end

  def name(ticker)
    StockQuote::Stock.company(ticker).company_name
  end

  def sector(ticker) # only used for original holdings table
    StockQuote::Stock.company(ticker).sector
  end

  def exchange(ticker)
    StockQuote::Stock.company(ticker).exchange
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
end
