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
    token = SecureRandom.hex(8)
    obj = [
      token,
      params[:name]
    ]
    CreateApplicationJob.perform_async(obj)
    render json: token, status: :created
  end

  # PATCH/PUT /applications/:token
  def update
    obj = [
      params[:token],
      params[:name]
    ]
    UpdateApplicationJob.perform_async(obj)
  end

  # DELETE /applications/:token
  def destroy
    @application.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by("token": params[:token])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:name)
    end
end
