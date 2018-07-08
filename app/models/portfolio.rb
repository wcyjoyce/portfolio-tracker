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
end
