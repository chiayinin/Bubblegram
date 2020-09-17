class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Do something later
    my_message = ApplicationController.render(
      partial: "messages/my_message",
      locals: {message: message}
    )

    other_message = ApplicationController.render(
      partial: "messages/other_message",
      locals: {message: message}
    )
    my_image = ApplicationController.render(
      partial: "messages/my_image",
      locals: {message: message}
    )
    other_image = ApplicationController.render(
      partial: "messages/other_image",
      locals: {message: message}
    )


    ActionCable.server.broadcast(
      "chat_channel_#{message.chat_id}",
      { my_message: my_message,
        other_message: other_message,
        my_image: my_image,
        other_image: other_image,
        message: message
      }
    )

  end
end