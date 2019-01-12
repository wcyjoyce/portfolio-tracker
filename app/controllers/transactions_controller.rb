class TransactionsController < ApplicationController
  before_action :set_portfolio, only: [:index]
  before_action :set_transaction, only: [:edit, :update, :destroy]

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.stock = Stock.find_or_create_by(ticker: @transaction.ticker)

    if @transaction.save
      redirect_to portfolio_path(@transaction.portfolio),
      notice: "#{@transaction.shares} shares of #{@transaction.ticker} has been added to #{@transaction.portfolio.name}!"
    else
      render :new,
      alert: "Sorry! There's something wrong with your transaction, please try adding it again."
    end
  end

  def edit
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to portfolio_path(@transaction.portfolio),
      notice: "Your transaction has been edited!"
    else
      render :edit,
      alert: "Sorry! There's something wrong with your transaction, please try editing it again."
    end
  end

  def destroy
    @transaction.destroy
    redirect_to portfolio_path(@transaction.portfolio),
    notice: "#{@transaction.shares} shares of #{@transaction.ticker} has been removed from #{@transaction.portfolio.name}!"
  end

  private

  def transaction_params
    params.require(:transaction).permit(:ticker, :shares, :added, :price, :stock_id, :portfolio_id)
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
