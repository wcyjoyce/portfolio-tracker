class Stock < ApplicationRecord
  has_many :transactions
  # validates :ticker, presence: true

  def self.historical_prices(stock, range)
    historical_url = "https://api.iextrading.com/1.0/stock/#{stock}/chart/#{range}"
    historical = JSON.parse(open(historical_url).read)
    chart = historical.collect { |historical| [historical["date"], historical["close"]] }
  end

  def self.day_chart(stock)
    # TODO: remove price values that are null
    historical_url = "https://api.iextrading.com/1.0/stock/#{stock}/chart/1d"
    historical = JSON.parse(open(historical_url).read)
    chart = historical.collect { |historical| [historical["minute"], historical["close"]] }
    # chart.reject { |price| price[1].null? }
  end

  def self.comps(stock)
    comps_url = "https://api.iextrading.com/1.0/stock/#{stock}/peers"
    comps = JSON.parse(open(comps_url).read)
  end

  def self.news(stock)
    news_url = "https://api.iextrading.com/1.0/stock/#{stock}/news"
    news = JSON.parse(open(news_url).read)
  end

  def country
    ticker.match(/^[a-zA-Z]/) ? "US" : "HK"
  end

  def market
  # TODO: market status for stock
  end
end
