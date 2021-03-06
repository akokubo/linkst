class AcquisitionsController < ApplicationController
  before_action :set_acquisition, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /acquisitions
  # GET /acquisitions.json
  def index
    @acquisitions = Acquisition.all
  end

  # GET /acquisitions/1
  # GET /acquisitions/1.json
  def show
  end

  # GET /acquisitions/new
  def new
    @acquisition = Acquisition.new
  end

  # GET /acquisitions/1/edit
  def edit
  end

  # POST /acquisitions
  # POST /acquisitions.json
  def create
    @acquisition = Acquisition.new(acquisition_params)

    respond_to do |format|
      if @acquisition.save
        format.html { redirect_to @acquisition, notice: t('activerecord.successful.messages.created', :model => Acquisition.model_name.human) }
        format.json { render :show, status: :created, location: @acquisition }
      else
        format.html { render :new }
        format.json { render json: @acquisition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acquisitions/1
  # PATCH/PUT /acquisitions/1.json
  def update
    respond_to do |format|
      if @acquisition.update(acquisition_params)
        format.html { redirect_to @acquisition, notice: t('activerecord.successful.messages.updated', :model => Acquisition.model_name.human) }
        format.json { render :show, status: :ok, location: @acquisition }
      else
        format.html { render :edit }
        format.json { render json: @acquisition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acquisitions/1
  # DELETE /acquisitions/1.json
  def destroy
    @acquisition.destroy
    respond_to do |format|
      format.html { redirect_to acquisitions_url, notice: t('activerecord.successful.messages.destroyed', :model => Acquisition.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acquisition
      @acquisition = Acquisition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acquisition_params
      params.require(:acquisition).permit(:mission_id, :category_id, :experience)
    end
end
