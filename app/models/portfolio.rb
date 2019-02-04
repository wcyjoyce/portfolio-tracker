class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :stocks, through: :transactions
  has_many :transactions, dependent: :destroy
  validates :name, presence: true

  def total_cost
    total_cost = 0
    transactions.each { |transaction| total_cost += transaction.total_cost }
    total_cost.to_i
  end

  def market_value
    market_value = 0
    transactions.each { |transaction| market_value += transaction.market_value }
    market_value.to_i
  end

  def profit_amount
    profit_amount = 0
    transactions.each { |transaction| profit_amount += transaction.profit_amount }
    profit_amount.to_i
  end

  def profit_pct
    # total_cost.zero? ? "-" : sprintf("%g%", (profit_amount.to_f / total_cost.to_f * 100).round(2))
    total_cost.zero? ? "-" : (profit_amount.to_f / total_cost.to_f * 100).round(2)
  end

  def inception
    if transactions.nil?
      transactions.order(added: :asc).first.added.strftime("%d %b %Y")
    else
      created_at.strftime("%d %b %Y")
    end
  end

  def annualised # currently not in use
    incepted_seconds = Date.today.to_time - inception.to_time
    incepted_days = incepted_seconds / 60 / 60 / 24
    annualised_return = ((100 + profit_pct) ** (365 / incepted_days)) - 100
    sprintf("%g%", annualised_return)
  end

  def ytd
    start_value = 0
    transactions.each do |transaction|
      stock_quote = StockQuote::Stock.quote(transaction.ticker)
      ytd_price = stock_quote.latest_price / (1 + stock_quote.ytd_change)
      ytd_value = ytd_price * transaction.shares
      start_value += ytd_value
    end
    # start_value.zero? ? "-" : sprintf("%g%", ((market_value.to_f / start_value.to_f - 1) * 100).round(2)).to_i
    start_value.zero? ? "-" : ((market_value.to_f / start_value.to_f - 1) * 100).round(2)
  end

  def duplicates
    array = transactions.to_a
    cache = Hash.new { |h,k| h[k] = { total_cost: 0, cumulative_shares: 0 } }

    array.each do |transaction|
      transaction_shares = transaction.shares
      transaction_cost = transaction.price
      cache[transaction.ticker][:cumulative_shares] += transaction_shares
      cache[transaction.ticker][:total_cost] += transaction_cost * transaction_shares
    end

    duplicates_table = cache.keys.map do |transaction_ticker|
      [
        company = StockQuote::Stock.company(transaction_ticker).company_name,
        ticker = transaction_ticker,
        sector = StockQuote::Stock.company(transaction_ticker).sector,
        quantity = cache[transaction_ticker][:cumulative_shares],
        avg_cost = (cache[transaction_ticker][:total_cost] / quantity).to_f.round(2),
        transaction_price = sprintf("%.2f", StockQuote::Stock.quote(transaction_ticker).latest_price).to_f,
        total_cost = cache[transaction_ticker][:total_cost].to_f,
        market_value = (quantity * transaction_price).round(2).to_f,
        ytd = sprintf("%.2f", sign((StockQuote::Stock.quote(transaction_ticker).ytd_change * 100).round(2))).to_s + "%",
        profit_amount = sign((market_value - total_cost).round(2)),
        profit_pct = sign((profit_amount.to_f / total_cost * 100).round(2))
      ]
    end
    duplicates_table.sort!
  end

  def duplicates_mobile
    array = transactions.to_a
    cache = Hash.new { |h,k| h[k] = { total_cost: 0, cumulative_shares: 0 } }

    array.each do |transaction|
      transaction_shares = transaction.shares
      transaction_cost = transaction.price
      cache[transaction.ticker][:cumulative_shares] += transaction_shares
      cache[transaction.ticker][:total_cost] += transaction_cost * transaction_shares
    end

    duplicables_mobile_table = cache.keys.map do |transaction_ticker|
      [
        # company = StockQuote::Stock.company(transaction_ticker).company_name,
        ticker = transaction_ticker,
        quantity = cache[transaction_ticker][:cumulative_shares],
        transaction_price = sprintf("%.2f", StockQuote::Stock.quote(transaction_ticker).latest_price).to_f,
        profit_pct = sign(((quantity * transaction_price - cache[transaction_ticker][:total_cost]).to_f / cache[transaction_ticker][:total_cost] * 100).round(2))
      ]
    end
  end

  def transaction_summary(ticker)
    array = transactions.to_a.select { |transaction| transaction.ticker == ticker}
    cache = Hash.new { |h,k| h[k] = { total_cost: 0, cumulative_shares: 0 } }

    array.each do |transaction|
      transaction_ticker = transaction.ticker
      @latest_price = StockQuote::Stock.quote(transaction_ticker).latest_price
      transaction_shares = transaction.shares
      transaction_cost = transaction.price
      cache[transaction_ticker][:cumulative_shares] += transaction_shares
      cache[transaction_ticker][:total_cost] += transaction_cost * transaction_shares
    end

    summary_table = cache.keys.map do |transaction_ticker|
      # [
        quantity = cache[transaction_ticker][:cumulative_shares],
        market_value = sprintf("%.2f", cache[transaction_ticker][:cumulative_shares] * @latest_price.to_f),
        avg_cost = sprintf("%.2f", cache[transaction_ticker][:total_cost] / cache[transaction_ticker][:cumulative_shares]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        profit_amount = sprintf("%.2f", (cache[transaction_ticker][:cumulative_shares] * @latest_price.to_f) - cache[transaction_ticker][:total_cost]).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
        profit_pct = ((((cache[transaction_ticker][:cumulative_shares] * @latest_price.to_f) - cache[transaction_ticker][:total_cost]) / cache[transaction_ticker][:total_cost]) * 100).round(2).to_s + "%"
      # ]
    end
    summary_table.sort!.flatten
  end

  def country_allocation
    array = transactions.to_a
    cache = Hash.new { |h,k| h[k] = { market_value: 0 } }

    array.each do |transaction|
      transaction_shares = transaction.shares
      transaction_price = StockQuote::Stock.quote(transaction.ticker).latest_price
      transaction_country = transaction.stock.country
      cache[transaction_country][:market_value] += transaction_shares * transaction_price
    end

    country_table = cache.keys.map { |transaction_country| [ transaction_country, cache[transaction_country][:market_value].to_i ] }
    country_table.sort!
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

    sector_table = cache.keys.map { |transaction_sector| [ transaction_sector, cache[transaction_sector][:market_value].to_i ] }
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

  def self.to_show_csv
    headers = ["Name", "Ticker", "Sector", "Quantity", "Cost", "Current Price", "Total Cost", "Market Value", "P&L (%)", "Return (%)", "Date Added"]
    portfolio = transactions.first.portfolio
    CSV.generate(headers: true) do |csv|
      csv << headers
      portfolio.each do |transaction|
        csv << [
          transaction.name(transaction.ticker),
          transaction.ticker.upcase,
          transaction.sector(transaction.ticker),
          transaction.shares,
          transaction.price,
          transaction.current_price(transaction.ticker),
          transaction.market_value,
          transaction.profit_amount,
          transaction.profit_pct,
          transaction.added.strftime("%d %b %Y")
        ]
      end
    end
  end

  def display(number)
    number > 0 ? "positive" : "negative"
  end

  def sign(number)
    number = number.to_f
    number > 0 ? sprintf("+%g", number) : number
  end
end
