require "open-uri"
require "nokogiri"

class Transaction < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock
  validates :ticker, :shares, :added, :price, presence: true
  validate :weekday, :not_in_future
  acts_as_paranoid

  def weekday
    errors.add(:added, "Trading is closed on weekends.") unless added.on_weekday?
    # TODO: deleted_at should only take place on weekdays as well
    # errors.add(:deleted_at, "Trading is closed on weekends.") unless deleted_at.present? && deleted_at.on_weekday?
  end

  def not_in_future
    errors.add(:added, "Your transaction cannot be in the future") if added.present? && added > Date.today
    errors.add(:deleted_at, "Your transaction cannot be in the future") if deleted_at.present? && deleted_at > Date.today
  end

  def historical_price
    month = deleted_at.strftime("%b")
    day = deleted_at.strftime("%d")
    year = deleted_at.strftime("%Y")
    # url = "https://www.investopedia.com/markets/api/partial/historical/?Symbol=FB&Type=%20Historical+Prices&Timeframe=Daily&StartDate=Jan+11%2C+2019&EndDate=Jan+11%2C+2019"
    url = "https://www.investopedia.com/markets/api/partial/historical/?Symbol=#{stock.ticker}&Type=%20Historical+Prices&Timeframe=Daily&StartDate=#{month}+#{day}%2C+#{year}&EndDate=#{month}+#{day}%2C+#{year}"
    html = Nokogiri::HTML(open(url).read)
    historical_price = html.css(".in-the-money .num[2]").text.strip
    return historical_price.to_f
  end

  def historical_profit_amount
    profit_amount = (price.to_f - historical_price) * shares
    profit_amount.to_f
  end

  def historical_profit_pct
    (historical_profit_amount / (historical_price * shares) * 100).round(2)
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

  def allocation
    (market_value / portfolio.market_value * 100).round(2)
  end

  def ytd(ticker)
    StockQuote::Stock.quote(ticker).ytd_change * 100
  end
end
