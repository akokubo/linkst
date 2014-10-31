class UsersController < ApplicationController
  before_action :set_user, only: [:show, :histories]
  before_action :award_web_access_bonus!, only: [:show, :histories]
  load_and_authorize_resource

  def index
    @categories = Category.all.order('id ASC')
    @users = User.all.order('id ASC')
  end

  def show
  end

  def histories
    if current_user.id == @user.id || current_user.has_role?("administrator") || current_user.has_role?("teacher")
      @histories = History.where(user_id: @user.id).order('created_at DESC')
    end
  end

  private

    def set_user
      @categories = Category.all.order('id ASC')
      @user = User.find_by(fpno: params[:fpno])
      if @user
        assigns = @user.assigns.order('id ASC')
        assigns.each do |assign|
          @user.histories.build(mission_id: assign.mission.id)
        end
      end
    end
end
