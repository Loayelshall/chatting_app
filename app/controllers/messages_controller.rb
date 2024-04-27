class MessagesController < ApplicationController
  before_action :set_application, :set_chat
  # before_action :set_chat
  before_action :set_message, only: %i[ show update destroy ]

  # GET /messages
  def index
    @messages = @chat.messages

    render json: @messages
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create
    message_number = get_next_number
    @message = @chat.messages.new(number: message_number, message: params[:message])
    @chat.increment!(:message_count)

    if @message.save and @chat.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  def update
   # creating a hashmap and passing it
    obj = [
      params[:application_token],
      params[:chat_number],
      params[:number],
      params[:message]
    ]
    UpdateMessageJob.perform_async(obj)
    render "message queued"
  end

  # # DELETE /messages/1
  def destroy
    @message.destroy!
    return $redis.lpop("#{@application.token}/#{@chat.number}/msg_numbers", @message.number)
    @chat.decrement!(:message_count)
    @chat.save
  end

  def search
    @result = Message.search(params[:message])
    render json: @result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by("token": params[:application_token])
    end

    def set_chat
      @chat = @application.chats.find_by("number": params[:chat_number]) if @application
    end

    def set_message
      @message = @chat.messages.find_by("number": params[:number]) if @chat
    end

    def get_next_number
      if $redis.lrange("#{@application.token}/#{@chat.number}/msg_numbers", -1, -1)
        return @chat.message_count + 1
      else
        return $redis.lpop("#{@application.token}/#{@chat.number}/msg_numbers")
      end
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:message)
    end
end
