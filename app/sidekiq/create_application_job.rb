class CreateApplicationJob
  include Sidekiq::Job

  def perform(*args)
    params = args[0]
    @application = Application.new(token: params[0], name: params[1])
    @application.save
    $redis.set("#{params[0]}_next_chat_number", 1)
  end
end
