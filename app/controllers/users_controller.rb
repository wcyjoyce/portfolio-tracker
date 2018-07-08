class UsersController < ApplicationController
  def dashboard
    @user = User.find(params[:id])
    # authorize @user
  end
end
