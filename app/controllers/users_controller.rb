class UsersController < ApplicationController
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    redirect_to "/" unless @user == current_user
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to "/", notice: 'User settings were successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def user_params
      params.require(:user).permit(:email_notification)
  end
end
