class UsersController < ApplicationController
  before_action :correct_user, only: [:show]
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in(@user)
        UserMailer.with(to: @user.email, name: @user.name).welcome.deliver_later # 追加
        format.html { redirect_to user_path(@user.id), notice: 'アカウントを登録しました。' }
        format.json { render :show, status: :created, location: @user }
        #redirect_to user_path(@user.id), notice: 'アカウントを登録しました。'
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        #render :new
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to current_user unless current_user?(@user)
  end
end
