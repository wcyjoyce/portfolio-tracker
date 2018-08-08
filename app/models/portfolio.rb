class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :stocks, dependent: :destroy
  validates :name, presence: true

  def total_cost
    total_cost = 0
    stocks.each { |stock| total_cost += stock.total_cost }
    total_cost
  end

  def market_value
    market_value = 0
    stocks.each { |stock| market_value += stock.market_value }
    market_value
  end

  def profit_amount
    profit_amount = 0
    stocks.each { |stock| profit_amount += stock.profit_amount }
    profit_amount
  end

  def profit_pct
    profit_amount / total_cost * 100
  end

  def inception
    stocks.order(added: :asc).first.added.strftime("%d %b %Y")
  end

  def annualised
    incepted_seconds = Date.today.to_time - inception.to_time
    incepted_days = incepted_seconds / 60 / 60 / 24
    annualised_return = ((100 + profit_pct) ** (365 / incepted_days)) - 100
    annualised_return.round(2)
  end

  def market_status
    status = StockQuote::Stock.quote(stocks.first.ticker).latest_source
    status == "Close" ? "closed" : "open"
  end

  def duplicates
    array = stocks.to_a
    cache = Hash.new { |h,k| h[k] = { total_cost: 0, cumulative_shares: 0 } }

    array.each do |stock|
      stock_ticker = stock.ticker
      stock_shares = stock.shares
      stock_cost = stock.price
      cache[stock_ticker][:cumulative_shares] += stock_shares
      cache[stock_ticker][:total_cost] += stock_cost * stock_shares
    end

    duplicates_table = cache.keys.map do |stock_ticker|
      [
        StockQuote::Stock.quote(stock_ticker).company_name,
        stock_ticker,
        cache[stock_ticker][:cumulative_shares].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        sprintf("%.2f", cache[stock_ticker][:total_cost] / cache[stock_ticker][:cumulative_shares]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        stock_price = sprintf("%.2f", StockQuote::Stock.quote(stock_ticker).latest_price).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        total_cost = sprintf("%.2f", cache[stock_ticker][:total_cost]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        market_value = sprintf("%.2f", cache[stock_ticker][:cumulative_shares] * stock_price.to_f).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        (StockQuote::Stock.quote(stock_ticker).ytd_change).round(2).to_s + "%",
        profit_amount = sprintf("%.2f", (cache[stock_ticker][:cumulative_shares] * stock_price.to_f) - cache[stock_ticker][:total_cost]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        ((((cache[stock_ticker][:cumulative_shares] * stock_price.to_f) - cache[stock_ticker][:total_cost]) / cache[stock_ticker][:total_cost]) * 100).round(2).to_s + "%"
      ]
    end
    duplicates_table.sort!
  end

  def sector_allocation
    array = stocks.to_a
    cache = Hash.new { |h,k| h[k] = { market_value: 0 } }

    array.each do |stock|
      stock_shares = stock.shares
      stock_price = StockQuote::Stock.quote(stock.ticker).latest_price
      stock_sector = StockQuote::Stock.company(stock.ticker).sector
      cache[stock_sector][:market_value] += stock_shares * stock_price
    end

    sector_table = cache.keys.map do |stock_sector|
      [
        stock_sector,
        sprintf("%.2f", cache[stock_sector][:market_value]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
      ]
    end
    sector_table.sort!
  end

  def holdings_allocation
    array = stocks.to_a
    cache = Hash.new { |h,k| h[k] = { market_value: 0 } }

    stocks.each do |stock|
      stock_ticker = stock.ticker
      stock_shares = stock.shares
      stock_price = StockQuote::Stock.quote(stock.ticker).latest_price
      cache[stock_ticker][:market_value] += stock_shares * stock_price
    end

    holdings_table = cache.keys.map do |stock_ticker|
      [
        stock_ticker,
        sprintf("%.2f", cache[stock_ticker][:market_value]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
      ]
    end
    holdings_table.sort!
  end
end
