class PortfoliosController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  def index
    @portfolios = Portfolio.all
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
      redirect_to root_path
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
  end

  def destroy
    authorize @portfolio
    @portfolio.destroy
    redirect_to root_path
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
