class PortfoliosController < ApplicationController
  # skip_before_action :authenticate_user!
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  def index
    @portfolios = Portfolio.all
    @user = @portfolios.first.user
    # @portfolios = policy_scope(Portfolio).order(name: :asc)
    csv_options = {col_sep: ',', force_quotes: true, quote_char: '"' }
    filepath = "app/views/portfolios/investments.csv"

    CSV.open(filepath, "wb", csv_options) do |csv|
      headers = ["Portfolio", "Name", "Ticker", "Sector", "Quantity", "Average Cost", "Current Price", "Total Cost", "Market Value", "YTD (%)", "P&L (%)", "Return (%)"]
      csv << headers
      @portfolios.each do |portfolio|
        portfolio.duplicates.each { |duplicate| csv << [portfolio[:name], duplicate].flatten }
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data @portfolios.to_csv, filename: "investments_#{Date.today}.csv"}
    end
  end

  def new
    @portfolio = Portfolio.new
    # authorize @portfolio
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.user = current_user
    # authorize @portfolio
    if @portfolio.save
      redirect_to portfolio_path(@portfolio)
    else
      render :new
    end
  end

  def show
    # authorize @portfolio
    csv_options = {col_sep: ',', force_quotes: true, quote_char: '"' }
    filepath = "app/views/portfolios/portfolio_#{@portfolio.name}.csv"

    CSV.open(filepath, "wb", csv_options) do |csv|
      headers = ["Name", "Ticker", "Sector", "Quantity", "Cost", "Current Price", "Total Cost", "Market Value", "P&L (%)", "Return (%)", "Date Added"]
      csv << headers
      @portfolio.transactions.each do |transaction|
        csv << [
          transaction.name(transaction.ticker),
          transaction.ticker.upcase,
          transaction.sector(transaction.ticker),
          transaction.shares,
          transaction.price,
          transaction.current_price(transaction.ticker),
          transaction.market_value,
          transaction.profit_amount,
          transaction.profit_pct,
          transaction.added.strftime("%d %b %Y")
        ]
      end
    end

    # TODO: export individual portfolio CSV
    respond_to do |format|
      format.html
      format.csv { send_data Portfolio.to_show_csv, filename: "#{@portfolio.name}_#{Date.today}.csv"}
    end
  end

  def edit
    # authorize @portfolio
  end

  def update
    # authorize @portfolio
    if @portfolio.update(portfolio_params)
      redirect_to portfolio_path(@portfolio)
    else
      render :edit
    end
  end

  def destroy
    # authorize @portfolio
    @portfolio.destroy
    redirect_to portfolios_path
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
