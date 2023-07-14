class Public::EndUsersController < ApplicationController
  #before_action :authenticate_end_user!
  before_action :set_end_user, only: [:favorites, :followings, :followers]

  def show
    @end_user = EndUser.find_by(id: params[:id])
  end

  def edit
    @end_user = current_end_user
    if @end_user.id != current_end_user.id
      redirect_to end_user_path(current_end_user)
    end
  end

  def update
    @end_user = current_end_user
    if @end_user.update(end_user_params)
      flash[:success] = "会員情報が変更されました。"
      redirect_to end_user_path(current_end_user.id)
    else
      render "edit"
    end
  end

  def favorites
    @favorite_posts = @end_user.favorite_posts
  end

  # フォロー一覧
  def followings
    end_user = EndUser.find(params[:id])
    @end_users = end_user.followings
  end

  # フォロワー一覧
  def followers
    end_user = EndUser.find(params[:id])
    @end_users = end_user.followers
  end

  def unsubscribe
    @end_user = current_end_user
  end

  def withdraw
    @end_user = current_end_user
    @end_user.update(is_active: false)
    reset_session
    redirect_to root_path
  end

  def search
    if params[:end_user_name].present?
      @end_users = EndUser.where('name LIKE ?', "%#{params[:end_user_name]}%")
    else
      @end_users = EndUser.none
    end
  end

  private

  def end_user_params
      params.require(:end_user).permit(:end_user_name, :email, :profile_image)
  end

  def set_end_user
    @end_user = EndUser.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:name, :image, :introduction)
  end


end
