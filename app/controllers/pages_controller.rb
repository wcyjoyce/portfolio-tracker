require "browser"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @sectors = ["spy", "communications", "technology", "utilities", "healthcare", "realestate", "materials", "consumer", "energy", "financials"]
    performance = []

    # sector_tickers = ["SPY", "XLC", "VGT", "XLU", "XLV", "VNQ", "XLB", "XLY", "XLE", "XLF"]
    performance_url = "https://api.iextrading.com/1.0/stock/market/sector-performance"
    sector_performance = JSON.parse(open(performance_url).read)

    spy_book = JSON.parse(open("https://api.iextrading.com/1.0/stock/SPY/book").read)
    performance_spy = ("#{spy_book['quote']['changePercent']}.".to_f * 100).round(2)
    performance << ["SPY", performance_spy]

    sector_performance.each { |sector| performance << [sector["name"], (sector["performance"].to_f * 100).round(2)] }
    @tab_details = @sectors.zip(performance)

    @chart_spy = Stock.day_chart("SPY")
    @chart_communications = Stock.day_chart("XLC")
    @chart_technology = Stock.day_chart("VGT")
    @chart_utilities = Stock.day_chart("XLU")
    @chart_healthcare = Stock.day_chart("XLV")
    @chart_realestate = Stock.day_chart("VNQ")
    @chart_materials = Stock.day_chart("XLB")
    @chart_consumer = Stock.day_chart("XLY")
    @chart_energy = Stock.day_chart("XLE")
    @chart_financials = Stock.day_chart("XLF")

    @library_options = {
      message: {empty: "Data unavailable"},
      colors: ["#616668"],
      chart: {backgroundColor: nil},
      vAxis: {gridlines: {color: "transparent"}},
      xAxis: {
        crosshair: false,
        labels: { enabled: false },
        gridLines: { display: false }
      },
      yAxis: {
        crosshair: false,
        labels: { enabled: false }
      }
    }
  end

  def about
  end
end
