class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /histories
  # GET /histories.json
  def index
    @histories = History.paginate(page: params[:page]).order('created_at DESC')
  end

  # GET /histories/1
  # GET /histories/1.json
  def show
  end

  # GET /histories/new
  def new
    @users = User.all
    @missions = Mission.all
    @history = History.new
  end

  # GET /histories/1/edit
  def edit
  end

  # POST /histories
  # POST /histories.json
  def create

    user_id = histories_params[:user_id].to_i
    user = User.find(user_id)
    if current_user.id == user_id || current_user.has_role?('administrator')
      mission_ids = histories_params[:mission_ids]
      histories = []
      if mission_ids
        mission_ids.each do |mission_id|
          if user.assigns.find_by(mission_id: mission_id)
            history = History.new(user_id: user_id, mission_id: mission_id)
            mission = Mission.find(mission_id)
            history.recent_experience = user.total_experience
            mission.acquisitions.each do |acquisition|
              category_id = acquisition.category_id
              status = user.statuses.find_by(category_id: category_id)
              status.experience += acquisition.experience
              status.save
            end
            history.experience = user.reload.total_experience
            histories << history
          end
        end

        if histories.count > 0
          History.transaction do
            histories.each do |history|
              history.save
            end
            user.reassign_missions
          end
        end
      end
    end
    redirect_to user_path(fpno: user.fpno)

=begin
    mission = @history.mission
    user = @history.user
    @history.recent_experience = user.total_experience
    mission.acquisitions.each do |acquisition|
      category_id = acquisition.category_id
      status = user.statuses.find_by(category_id: category_id)
      status.experience += acquisition.experience
      status.save
    end
    @history.experience = user.reload.total_experience

    user.reassign_missions

    respond_to do |format|
      if @history.save
        format.html { redirect_to user_path(fpno: user.fpno), notice: t('activerecord.successful.messages.created', :model => History.model_name.human) }
        format.json { render :show, status: :created, location: @history }
      else
        format.html { render :new }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # PATCH/PUT /histories/1
  # PATCH/PUT /histories/1.json
  def update
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: t('activerecord.successful.messages.updated', :model => History.model_name.human) }
        format.json { render :show, status: :ok, location: @history }
      else
        format.html { render :edit }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /histories/1
  # DELETE /histories/1.json
  def destroy
    @history.destroy
    respond_to do |format|
      format.html { redirect_to histories_url, notice: t('activerecord.successful.messages.destroyed', :model => History.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
=begin
    def history_params
      params.require(:history).permit(:user_id, :mission_id)
    end
=end

    def histories_params
      params.require(:histories).permit(:user_id, mission_ids: [])
#      params.require(:history).permit(:user_id, mission_id: [])
    end
end
