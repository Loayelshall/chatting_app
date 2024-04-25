class ApplicationsController < ApplicationController
  before_action :set_application, only: [ :show, :update, :destroy ]
  before_action :application_params, only: [:create, :update]

  # GET /applications
  def index
    @applications = Application.all

    render json: @applications
  end

  # GET /applications/1
  def show
    render json: @application
  end

  # POST /applications
  def create
    @application = Application.new(application_params)
    @application.app_token = SecureRandom.hex(8)
    if @application.save
      render json: @application, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/:app_token
  def update
    if @application.update(application_params)
      render json: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:app_token
  def destroy
    @application.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by("app_token": params[:app_token])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:name)
    end
end
