class UpdateApplicationJob
  include Sidekiq::Job

  def perform(*args)
    params = args[0]
    @application = Application.find_by("token": params[0])
    @application.with_lock do
      @application.update(name: params[1])
    end
  end
end
