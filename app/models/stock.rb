class Stock < ApplicationRecord
  has_many :transactions
  # validates :ticker, presence: true

  def self.historical_prices(stock, range)
    historical_url = "https://api.iextrading.com/1.0/stock/#{stock}/chart/#{range}"
    historical = JSON.parse(open(historical_url).read)
    chart = historical.collect { |historical| [historical["date"], historical["close"]] }
  end

  def self.day_chart(stock)
    historical_url = "https://api.iextrading.com/1.0/stock/#{stock}/chart/1d"
    historical = JSON.parse(open(historical_url).read)
    chart = historical.collect { |historical| [historical["minute"], historical["close"]] }
    chart.reject { |price| price[1].nil? }
  end

  def self.comps(stock)
    comps_url = "https://api.iextrading.com/1.0/stock/#{stock}/peers"
    comps = JSON.parse(open(comps_url).read)
    comps.first(5).include?(comps.last) ? comps = comps.first(5).unshift(stock) : comps = comps.first(5).unshift(stock) << comps.last
    comps_table = []

    comps.reject! { |comp| comp.nil? }
    comps.each do |comp|
      stats = JSON.parse(open("https://api.iextrading.com/1.0/stock/#{comp}/stats").read)
      book = JSON.parse(open("https://api.iextrading.com/1.0/stock/#{comp}/book").read)

      market_cap = ("#{book['quote']['marketCap']}").to_f
      market_cap >= 1000000000 ? market_cap = (market_cap / 1000000000).round(2).to_s + "B" : market_cap = (market_cap / 1000000).round(2).to_s + "M"

      row = [
        name = "#{stats['companyName']}",
        ticker = comp,
        latest_price = ("#{book['quote']['latestPrice']}").to_f,
        market_cap,
        day_change = ("#{book['quote']['changePercent']}".to_f * 100).round(2),
        price_range = "#{book['quote']['high']}" + " / " + "#{book['quote']['low']}",
        ytd_change = ("#{book['quote']['ytdChange']}".to_f * 100).round(2),
        pe_ratio = ("#{book['quote']['peRatio']}").to_f,
        beta = ("#{stats['beta']}".to_f).round(2),
        roe = ("#{stats['returnOnEquity']}").to_f,
        eps = ("#{stats['latestEPS']}").to_f,
        # dividend_yield = ("#{stats['dividendYield']}".to_f).round(2)
      ]
      row.map! { |r| r == 0 ? "-" : r}
      comps_table << row
    end
    comps_table
  end

  def self.comps_mobile(stock)
    # ticker, price range, market cap, YTD
    comps_table = Stock.comps(stock)
    mobile_comps = []
    comps_table.each do |detail|
      row = []
      row << detail[1] << detail[5] << detail[3] << detail[6]
      mobile_comps << row
    end
    mobile_comps
  end

  def self.news(stock)
    news_url = "https://api.iextrading.com/1.0/stock/#{stock}/news"
    news = JSON.parse(open(news_url).read)
  end

  def country
    ticker.match(/^[a-zA-Z]/) ? "US" : "HK"
  end
end
