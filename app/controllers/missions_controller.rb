class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /missions
  # GET /missions.json
  def index
    @missions = Mission.paginate(page: params[:page])
    @categories = Category.all
  end

  # GET /missions/1
  # GET /missions/1.json
  def show
  end

  # GET /missions/new
  def new
    @mission = Mission.new
    @levels = Level.all
    @categories = Category.all
    @categories.each do |category|
      @mission.acquisitions.build(category_id: category.id, experience: 0)
    end
  end

  # GET /missions/1/edit
  def edit
    @levels = Level.all
    @categories = Category.all
  end

  # POST /missions
  # POST /missions.json
  def create
    @mission = Mission.new(mission_params)

    #render plain: params

    respond_to do |format|
      if @mission.save
        format.html { redirect_to @mission, notice: t('activerecord.successful.messages.created', :model => Mission.model_name.human) }
        format.json { render :show, status: :created, location: @mission }
      else
        format.html { render :new }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /missions/1
  # PATCH/PUT /missions/1.json
  def update
    respond_to do |format|
      if @mission.update(mission_params)
        format.html { redirect_to @mission, notice: t('activerecord.successful.messages.updated', :model => Mission.model_name.human) }
        format.json { render :show, status: :ok, location: @mission }
      else
        format.html { render :edit }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    @mission.destroy
    respond_to do |format|
      format.html { redirect_to missions_url, notice: t('activerecord.successful.messages.destroyed', :model => Mission.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:id])
      @categories = Category.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mission_params
      params.require(:mission).permit(:description, :category_id, :level_id, acquisitions_attributes: [:id, :category_id, :experience])
    end
end
