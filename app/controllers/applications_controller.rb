class ApplicationsController < ApplicationController
  before_action :set_application, only: [ :show, :update, :destroy ]
  before_action :application_params, only: [:create, :update]

  # GET /applications
  def index
    @applications = Application.all
    render json: @applications, :except=> [:id]
  end

  # GET /applications/1
  def show
    render json: @application, :except=> [:id]
  end

  # POST /applications
  def create
    timestamp = Time.now.to_i
    token = SecureRandom.hex(8) + timestamp.to_s
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
    render "application updated successfully", status: :ok
  end

  # DELETE /applications/:token
  def destroy
    @application.destroy
    render "application deleted successfully", status: :ok
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
