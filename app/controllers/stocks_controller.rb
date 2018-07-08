require "json"
require "open-uri"

class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search, :result]

  # def search
  #   if params[:stock]
  #     @stock = Stock.find_by_ticker(params[:stock])
  #     @stock ||= Stock.new_from_lookup(params[:stock])
  #   end

  #   if @stock
  #     render "stocks/lookup"
  #   else
  #     redirect_to root_path
  #   end
  # end

  def result
    @query = params[:stock]

    # stock_quote gem
    @result = StockQuote::Stock.quote(@query)

    # IE Trading API
    url = "https://api.iextrading.com/1.0/stock/#{@query}/company"
    result = JSON.parse(open(url).read)
    @tags = "#{result['tags']}"
  end

  def search
  end
end
