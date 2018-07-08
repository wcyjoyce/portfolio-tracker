require "json"
require "open-uri"

class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search, :result]
  # before_action :set_portfolio, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  def result
    @query = params[:stock]

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

    stats_url = "https://api.iextrading.com/1.0/stock/#{@query}/stats"
      stats = JSON.parse(open(stats_url).read)
      @high_52 = "#{stats['week52high']}"
      @low_52 = "#{stats['week52low']}"
      @beta = "#{stats['beta']}"
      @dividend_yield = "#{stats['dividendYield']}"
      @eps = "#{stats['latestEPS']}"
      @roe = "#{stats['returnOnEquity']}"
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
      redirect_to portfolios_path
    else
      render :new
    end
  end

  def edit
    # authorize @stock
  end

  def update
    # authorize @stock
    if @stock.update(stock_params)
      redirect_to portfolio_path(@stock.portfolio)
    else
      render :edit
    end
  end

  def destroy
    # authorize @stock
    @stock.destroy
    redirect_to portfolios_path
  end

  private

  def stock_params
    params.require(:stock).permit(:name, :ticker, :shares, :added, :price, :portfolio_id)
  end

  def set_stock
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
