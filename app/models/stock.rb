class Stock < ApplicationRecord
  has_many :transactions
  # validates :ticker, presence: true

  # def name(ticker)
  #   StockQuote::Stock.company(ticker).company_name
  # end

  # def sector(ticker) # only used for original holdings table
  #   StockQuote::Stock.company(ticker).sector
  # end

  def exchange(ticker)
    exchange = StockQuote::Stock.company(ticker).exchange

    if exchange == "Nasdaq Global Select"
      "NSQ"
    elsif exchange == "New York Stock Exchange"
      "NYSE"
    else
      exchange
    end
  end

  def self.historical_prices(stock, range)
    historical_url = "https://api.iextrading.com/1.0/stock/#{stock}/chart/#{range}"
    historical = JSON.parse(open(historical_url).read)
    chart = historical.collect { |historical| [historical['date'], historical['close']] }
  end

  def market_status(ticker)
    status = StockQuote::Stock.quote(ticker).latest_source
    status == "Close" ? "closed" : "open"
  end
end
