require "json"
require "open-uri"

class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search, :result]
  # before_action :set_portfolio, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  def result
    @query = params[:stock]

    unless @query.empty? || @query.nil?
      ## stock_quote gem
      # @result = StockQuote::Stock.quote(@query)

      # IE Trading API
      company_url = "https://api.iextrading.com/1.0/stock/#{@query}/company"
        company = JSON.parse(open(company_url).read)
        @name = "#{company['companyName']}"
        @symbol = "#{company['symbol']}"
        @exchange = "#{company['exchange']}"
        @sector = "#{company['sector']}"
        @description = "#{company['description']}"

      book_url = "https://api.iextrading.com/1.0/stock/#{@query}/book"
        book = JSON.parse(open(book_url).read)
        @update = Time.at("#{book['quote']['latestUpdate']}".to_i).to_datetime.strftime("%e %b %Y %H:%M:%S%p")
        @price = "#{book['quote']['latestPrice']}"
        @open = "#{book['quote']['open']}"
        @close = "#{book['quote']['close']}"
        @high = "#{book['quote']['high']}"
        @low = "#{book['quote']['low']}"
        @market_cap = "#{book['quote']['marketCap']}"
        @pe_ratio = "#{book['quote']['peRatio']}"

      historical_url = "https://api.iextrading.com/1.0/stock/#{@query}/chart/5y"
        historical = JSON.parse(open(historical_url).read)
        @chart = historical.collect { |historical| [historical['date'], historical['close']] }
        @library_options = {
          xAxis: {
            crosshair: true,
            title: {text: "date"}
          },
          yAxis: {
            crosshair: true,
            title: {text: "price"},
          }
        }

      stats_url = "https://api.iextrading.com/1.0/stock/#{@query}/stats"
        stats = JSON.parse(open(stats_url).read)
        @high_52 = "#{stats['week52high']}"
        @low_52 = "#{stats['week52low']}"
        @beta = "#{stats['beta']}"
        @dividend_yield = "#{stats['dividendYield']}"
        @eps = "#{stats['latestEPS']}"
        @roe = "#{stats['returnOnEquity']}"
        @eps_date = "#{stats['latestEPSDate']}"

      comps_url = "https://api.iextrading.com/1.0/stock/#{@query}/peers"
        @comps = JSON.parse(open(comps_url).read)
    end
  end

  def search
  end

  def new
    @stock = Stock.new
    # authorize @stock
  end

  def create
    @stock = Stock.new(stock_params)
    # authorize @stock
    if @stock.save
      redirect_to portfolio_path(@stock.portfolio),
      notice: "#{@stock.shares} shares of #{@stock.ticker} added to #{@stock.portfolio.name}!"
    else
      render :new, alert: "something wrong!"
    end
  end

  def show
    # authorize @stock
    @query = @stock.ticker

    company_url = "https://api.iextrading.com/1.0/stock/#{@query}/company"
      company = JSON.parse(open(company_url).read)
      @name = "#{company['companyName']}"
      @symbol = "#{company['symbol']}"
      @exchange = "#{company['exchange']}"
      @sector = "#{company['sector']}"
      @description = "#{company['description']}"

    book_url = "https://api.iextrading.com/1.0/stock/#{@query}/book"
      book = JSON.parse(open(book_url).read)
      @update = Time.at("#{book['quote']['latestUpdate']}".to_i).to_datetime.strftime("%e %b %Y %H:%M:%S%p")
      @price = "#{book['quote']['latestPrice']}"
      @open = "#{book['quote']['open']}"
      @close = "#{book['quote']['close']}"
      @high = "#{book['quote']['high']}"
      @low = "#{book['quote']['low']}"
      @market_cap = "#{book['quote']['marketCap']}"
      @pe_ratio = "#{book['quote']['peRatio']}"

      historical_url = "https://api.iextrading.com/1.0/stock/#{@query}/chart/5y"
        historical = JSON.parse(open(historical_url).read)
        @chart = historical.collect { |historical| [historical['date'], historical['close']] }
        @library_options = {
          xAxis: {
            crosshair: true,
            title: {text: "date"}
          },
          yAxis: {
            crosshair: true,
            title: {text: "price"},
          }
        }

    stats_url = "https://api.iextrading.com/1.0/stock/#{@query}/stats"
      stats = JSON.parse(open(stats_url).read)
      @high_52 = "#{stats['week52high']}"
      @low_52 = "#{stats['week52low']}"
      @beta = "#{stats['beta']}"
      @dividend_yield = "#{stats['dividendYield']}"
      @eps = "#{stats['latestEPS']}"
      @roe = "#{stats['returnOnEquity']}"
      @eps_date = "#{stats['latestEPSDate']}"

    comps_url = "https://api.iextrading.com/1.0/stock/#{@query}/peers"
      @comps = JSON.parse(open(comps_url).read)

    # render :result
  end

  def edit
    # authorize @stock
  end

  def update
    # authorize @stock
    if @stock.update(stock_params)
      redirect_to portfolio_path(@stock.portfolio),
      notice: "edited!"
    else
      render :edit
    end
  end

  def destroy
    # authorize @stock
    @stock.destroy
    redirect_to portfolio_path(@stock.portfolio),
    notice: "#{@stock.shares} shares of #{@stock.ticker} removed from #{@stock.portfolio.name}!"
  end

  private

  def stock_params
    params.require(:stock).permit(:name, :ticker, :shares, :added, :price, :portfolio_id)
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
