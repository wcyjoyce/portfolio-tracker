require "json"
require "open-uri"
require "date"

class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search, :result]
  before_action :set_portfolio, only: [:new, :create]
  before_action :set_stock, only: [:destroy]

  def search
  end

  def result
    @query = params[:stock]

    unless @query.empty? || @query.nil?
      company_url = "https://api.iextrading.com/1.0/stock/#{@query}/company"
        company = JSON.parse(open(company_url).read)
        @name = "#{company['companyName']}"
        @symbol = "#{company['symbol']}"
        @exchange = "#{company['exchange']}"
        @sector = "#{company['sector']}"
        @description = "#{company['description']}"
        @website = "#{company['website']}"

      book_url = "https://api.iextrading.com/1.0/stock/#{@query}/book"
        book = JSON.parse(open(book_url).read)
        @update = DateTime.strptime("#{book['quote']['latestUpdate']}", "%Q").to_datetime.strftime("%e %b %Y %H:%M:%S%p")
        @price = "#{book['quote']['latestPrice']}"
        @open = "#{book['quote']['open']}"
        @close = "#{book['quote']['close']}"
        @high = "#{book['quote']['high']}"
        @low = "#{book['quote']['low']}"
        @change_amount_day = @price.to_f - @open.to_f
        @change_pct_day = @change_amount_day / @open.to_f * 100
        @market_cap = "#{book['quote']['marketCap']}"
        @pe_ratio = "#{book['quote']['peRatio']}"
        @avg_volume = "#{book['quote']['avgTotalVolume']}"

      stats_url = "https://api.iextrading.com/1.0/stock/#{@query}/stats"
        stats = JSON.parse(open(stats_url).read)
        @high_52 = "#{stats['week52high']}"
        @low_52 = "#{stats['week52low']}"
        @beta = "#{stats['beta']}"
        @dividend_yield = "#{stats['dividendYield']}"
        @eps = "#{stats['latestEPS']}"
        @roe = "#{stats['returnOnEquity']}"
        @eps_date = "#{stats['latestEPSDate']}"

      @chart_5y = Stock.historical_prices(@query, "5y")
      @chart_1y = Stock.historical_prices(@query, "1y")
      @chart_6m = Stock.historical_prices(@query, "6m")
      @chart_1m = Stock.historical_prices(@query, "1m")
      @chart_1d = Stock.day_chart(@query)
      @chart_ytd = Stock.historical_prices(@query, "ytd")

      @library_options = {
        message: {empty: "Data unavailable"},
        colors: ["#616668"],
        chart: {backgroundColor: nil},
        xAxis: {
          crosshair: false,
          title: {text: "DATE"}
        },
        yAxis: {
          crosshair: false,
          title: {text: "PRICE"},
        }
      }

      @comps = Stock.comps(@query)
      @articles = Stock.news(@query)
    end
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)
    puts @stock.errors.full_messages unless @stock.save
  end

  def destroy
  end

  private

  def stock_params
    params.require(:stock).permit(:ticker, :portfolio_id)
  end

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end
end
