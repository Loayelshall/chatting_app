class ChatsController < ApplicationController
  before_action :set_application, only: %i[ index show destroy ]
  before_action :set_chat, only: %i[ show destroy ]

  # GET /chats
  def index
    @chats = @application.chats
    render json: @chats,  :except=> [:id, :application_id]
  end

  # GET /chats/1
  def show
    render json: @chat, :except=> [:id, :application_id]
  end

  # POST /chats
  def create
    chat_number = get_next_number
    $redis.set("#{@application.token}_#{@chat.number}_next_message_number", 1)
    obj = [
      params[:application_token],
      chat_number
    ]
    CreateChatJob.perform_async(obj)
    render json: {number: chat_number, message_count: 0}, status: :created
  end

  # DELETE /chats/1
  def destroy
    @chat.with_lock do
      @chat.destroy!
    end
    @application.with_lock do
      @application.decrement!(:chats_count)
    end
    render "chat deleted successfully", status: :ok
  end

  private
    def set_application
      @application = Application.find_by("token": params[:application_token])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = @application.chats.find_by("number": params[:number]) if @application
    end

    def get_next_number
      $redis_lock.lock("#{@application.token}_next_chat_number", 2000) do |locked|
        output = $redis.get("#{@application.token}_next_chat_number")
        $redis.set("#{@application.token}_next_chat_number", output.to_i + 1)
        return output
      end
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:number)
    end
end
