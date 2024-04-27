class CreateChatJob
  include Sidekiq::Job

  def perform(*args)
    params = args[0]
    @application = Application.find_by("token": params[0])
    @chat = @application.chats.new(number: params[1])
    @application.increment!(:chats_count)
    @chat.save
    @application.with_lock do
      @application.save
    end
  end
end
