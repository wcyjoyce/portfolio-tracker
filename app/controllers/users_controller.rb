class UsersController < ApplicationController
  before_action :set_user

  def dashboard
  end

  def transactions
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end