class PortfoliosController < ApplicationController
  # skip_before_action :authenticate_user!
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  def index
    @portfolios = policy_scope(Portfolio).order(created_at: :asc)
  end

  def new
    @portfolio = Portfolio.new
    authorize @portfolio
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.user = current_user
    authorize @portfolio
    if @portfolio.save
      redirect_to portfolio_path(@portfolio)
    else
      render :new
    end
  end

  def show
    authorize @portfolio
  end

  def edit
    authorize @portfolio
  end

  def update
    authorize @portfolio
    if @portfolio.update(portfolio_params)
      redirect_to portfolio_path(@portfolio)
    else
      render :edit
    end
  end

  def destroy
    authorize @portfolio
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
