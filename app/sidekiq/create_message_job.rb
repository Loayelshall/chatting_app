class CreateMessageJob
  include Sidekiq::Job

  def perform(*args)
    params = args[0]
    @application = Application.find_by("token": params[0])
    @chat = @application.chats.find_by("number": params[1]) if @application
    @message = @chat.messages.new(number: params[2], message: params[3])
    @chat.with_lock do
      @chat.increment!(:message_count)
      @chat.save
    end
    @message.save

  end
end
