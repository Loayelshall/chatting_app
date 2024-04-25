class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: %i[ show destroy ]

  # GET /chats
  def index
    @chats = @application.chats

    render json: @chats
  end

  # GET /chats/1
  def show
    render json: @chat
  end

  # POST /chats
  def create
    @chat = @application.chats.new(number: @application.chats_count + 1)
    @application.increment!(:chats_count)

    if @chat.save and @application.save
      render json: @chat.number, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chats/1
  def destroy
    @chat.destroy!
  end

  private
    def set_application
      @application = Application.find_by("token": params[:application_token])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = @application.chats.find_by("number": params[:number]) if @application
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:number)
    end
end
