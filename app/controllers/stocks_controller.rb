require "json"
require "open-uri"

class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search, :result]

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

      historical_5y_url = "https://api.iextrading.com/1.0/stock/#{@query}/chart/5y"
        historical_5y = JSON.parse(open(historical_5y_url).read)
        @chart_5y = historical_5y.collect { |historical| [historical['date'], historical['close']] }

      historical_1y_url = "https://api.iextrading.com/1.0/stock/#{@query}/chart/1y"
        historical_1y = JSON.parse(open(historical_1y_url).read)
        @chart_1y = historical_1y.collect { |historical| [historical['date'], historical['close']] }

      historical_6m_url = "https://api.iextrading.com/1.0/stock/#{@query}/chart/6m"
        historical_6m = JSON.parse(open(historical_6m_url).read)
        @chart_6m = historical_6m.collect { |historical| [historical['date'], historical['close']] }

      historical_1m_url = "https://api.iextrading.com/1.0/stock/#{@query}/chart/1m"
        historical_1m = JSON.parse(open(historical_1m_url).read)
        @chart_1m = historical_1m.collect { |historical| [historical['label'], historical['close']] }

      historical_ytd_url = "https://api.iextrading.com/1.0/stock/#{@query}/chart/ytd"
        historical_ytd = JSON.parse(open(historical_ytd_url).read)
        @chart_ytd = historical_ytd.collect { |historical| [historical['date'], historical['close']] }

      @library_options = {
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

  private

  def stock_params
    params.require(:stock).permit(:name, :ticker, :portfolio_id)
  end
end
