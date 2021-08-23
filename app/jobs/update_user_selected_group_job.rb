class UpdateUserSelectedGroupJob < ApplicationJob
  queue_as :default

  def perform(group, user)
    byebug
    # Do something later
  end
end
