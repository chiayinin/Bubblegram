class MessagesController < ApplicationController
def create
  chat_room = Chat.find(params[:chat_id])
  @message = chat_room.messages.create(params_message)
  html = render(
    partial: "messages/message"
    locals: {message: @message}
  )
  ActionCable.server.broadcast "chat_channel_#{@message.chat_id}", html: html
  # @message.save
  # redirect_to chat_path(chat_room)
end

private
def params_message
  params.require(:message).permit(:content).merge(user: current_user)
end

end
