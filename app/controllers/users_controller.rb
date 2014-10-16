class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  load_and_authorize_resource

  def index
    @categories = Category.all
    @users = User.all
  end

  def show
  end

  private

    def set_user
      @categories = Category.all
      @user = User.find_by(idm: params[:idm])
    end
end
