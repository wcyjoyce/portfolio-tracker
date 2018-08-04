require "date"

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

  def duplicates
    tickers = stocks.map { |stock| stock.ticker }.uniq
      # array = stocks.select { |stock| ticker == stock.ticker }
  #     # .map do |dummy, qty, price|
  #     #   [qty, (price * qty)]
  #     # end
  #     # total_qty = selected_array.sum{ |ele| ele.ticker }
  #     # total_price = selected_array.sum{ |ele| ele.price }
  #     # [ticker, total_qty,total_price / total_qty]
    # end
  end
end
