class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :stocks, through: :transactions
  has_many :transactions, dependent: :destroy
  validates :name, presence: true

  def total_cost
    total_cost = 0
    transactions.each { |transaction| total_cost += transaction.total_cost }
    total_cost
  end

  def market_value
    market_value = 0
    transactions.each { |transaction| market_value += transaction.market_value }
    market_value
  end

  def profit_amount
    profit_amount = 0
    transactions.each { |transaction| profit_amount += transaction.profit_amount }
    profit_amount
  end

  def profit_pct
    "#{(profit_amount / total_cost * 100).round(2)}%"
  end

  def inception
    transactions.order(added: :asc).first.added.strftime("%d %b %Y")
  end

  def annualised
    incepted_seconds = Date.today.to_time - inception.to_time
    incepted_days = incepted_seconds / 60 / 60 / 24
    annualised_return = ((100 + profit_pct) ** (365 / incepted_days)) - 100
    annualised_return.round(2)
  end

  def ytd
    start_value = 0
    transactions.each do |transaction|
      stock_quote = StockQuote::Stock.quote(transaction.ticker)
      ytd_price = stock_quote.latest_price / (1 + stock_quote.ytd_change)
      ytd_value = ytd_price * transaction.shares
      start_value += ytd_value
    end
    "#{((market_value / start_value - 1) * 100).round(2)}%"
  end

  def duplicates
    array = transactions.to_a
    cache = Hash.new { |h,k| h[k] = { total_cost: 0, cumulative_shares: 0 } }

    array.each do |transaction|
      transaction_ticker = transaction.ticker
      transaction_shares = transaction.shares
      transaction_cost = transaction.price
      cache[transaction_ticker][:cumulative_shares] += transaction_shares
      cache[transaction_ticker][:total_cost] += transaction_cost * transaction_shares
    end

    duplicates_table = cache.keys.map do |transaction_ticker|
      [
        StockQuote::Stock.company(transaction_ticker).company_name,
        transaction_ticker,
        StockQuote::Stock.company(transaction_ticker).sector,
        cache[transaction_ticker][:cumulative_shares],
        sprintf("%.2f", cache[transaction_ticker][:total_cost] / cache[transaction_ticker][:cumulative_shares]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        transaction_price = sprintf("%.2f", StockQuote::Stock.quote(transaction_ticker).latest_price),
        total_cost = sprintf("%.2f", cache[transaction_ticker][:total_cost]),
        # market_value = sprintf("%.2f", cache[transaction_ticker][:cumulative_shares] * transaction_price.to_f).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        market_value = sprintf("%.2f", cache[transaction_ticker][:cumulative_shares] * transaction_price.to_f),
        sprintf("%.2f", (StockQuote::Stock.quote(transaction_ticker).ytd_change * 100).round(2)).to_s + "%",
        profit_amount = sprintf("%.2f", (cache[transaction_ticker][:cumulative_shares] * transaction_price.to_f) - cache[transaction_ticker][:total_cost]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        ((((cache[transaction_ticker][:cumulative_shares] * transaction_price.to_f) - cache[transaction_ticker][:total_cost]) / cache[transaction_ticker][:total_cost]) * 100).round(2).to_s + "%"
      ]
    end
    duplicates_table.sort!
  end

  def sector_allocation
    array = transactions.to_a
    cache = Hash.new { |h,k| h[k] = { market_value: 0 } }

    array.each do |transaction|
      transaction_shares = transaction.shares
      transaction_price = StockQuote::Stock.quote(transaction.ticker).latest_price
      transaction_sector = StockQuote::Stock.company(transaction.ticker).sector
      cache[transaction_sector][:market_value] += transaction_shares * transaction_price
    end

    sector_table = cache.keys.map { |transaction_sector| [ transaction_sector,cache[transaction_sector][:market_value].to_i ] }
    sector_table.sort!
  end

  def holdings_allocation
    array = transactions.to_a
    cache = Hash.new { |h,k| h[k] = { market_value: 0 } }

    transactions.each do |transaction|
      transaction_ticker = transaction.ticker
      transaction_shares = transaction.shares
      transaction_price = StockQuote::Stock.quote(transaction.ticker).latest_price
      cache[transaction_ticker][:market_value] += transaction_shares * transaction_price
    end

    holdings_table = cache.keys.map { |transaction_ticker| [ transaction_ticker, cache[transaction_ticker][:market_value].to_i ] }
    holdings_table.sort!
  end

  def self.to_csv
    headers = ["Portfolio", "Name", "Ticker", "Sector", "Quantity", "Average Cost", "Current Price", "Total Cost", "Market Value", "YTD (%)", "P&L ($)", "Return (%)"]
    CSV.generate(headers: true) do |csv|
      csv << headers
      all.each do |portfolio|
        portfolio.duplicates.each { |duplicate| csv << [portfolio[:name], duplicate].flatten }
      end
    end
  end
end
