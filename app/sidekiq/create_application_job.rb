class CreateApplicationJob
  include Sidekiq::Job

  def perform(*args)
    params = args[0]
    @application = Application.new(token: params[0], name: params[1])
    @application.save
  end
end
