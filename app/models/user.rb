class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :portfolios, dependent: :destroy
  has_many :stocks, through: :portfolios
  has_many :transactions, through: :portfolios

  # validates :first_name, :last_name, presence: true
  # validates :email, presence: true, uniqueness: true

  # def full_name
  #   "#{first_name.capitalize} #{last_name.capitalize}"
  # end

  def market_value
    market_value = 0
    portfolios.each { |portfolio| market_value += portfolio.market_value }
    market_value
  end

  def profit_amount
    profit_amount = 0
    portfolios.each { |portfolio| profit_amount += portfolio.profit_amount }
    profit_amount
  end

  def profit_pct
    total_cost = 0
    portfolios.each { |portfolio| total_cost += portfolio.total_cost }
    "#{(profit_amount / total_cost * 100).round(2)}%"
  end
end
