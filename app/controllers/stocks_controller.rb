class StocksController < ApplicationController
  skip_before_action :authenticate_user!
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
    @result = StockQuote::Stock.quote(@query)
  end

  def search
  end
end
