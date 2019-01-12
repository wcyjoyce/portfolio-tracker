class Stock < ApplicationRecord
  has_many :transactions
  # validates :ticker, presence: true

  def self.historical_prices(stock, range)
    historical_url = "https://api.iextrading.com/1.0/stock/#{stock}/chart/#{range}"
    historical = JSON.parse(open(historical_url).read)
    chart = historical.collect { |historical| [historical["date"], historical["close"]] }
  end

  def self.comps(stock)
    comps_url = "https://api.iextrading.com/1.0/stock/#{stock}/peers"
    comps = JSON.parse(open(comps_url).read)
  end
end
