class UpdateMessageJob
  include Sidekiq::Job

  def perform(*args)
    params = args[0]
    @application = Application.find_by("token": params[0])
    @chat = @application.chats.find_by("number": params[1]) if @application
    @message = @chat.messages.find_by("number": params[2]) if @chat
    @message.with_lock do
      @message.update(message: params[3])
    end
  end
end
