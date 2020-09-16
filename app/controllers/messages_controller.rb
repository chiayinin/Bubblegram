class MessagesController < ApplicationController
def create
  chat_room = Chat.find(params[:chat_id])
  @message = chat_room.messages.create(params_message)

  SendMessageJob.perform_later(@message)
  # @message.save
  # redirect_to chat_path(chat_room)
end

private
def params_message
  params.require(:message).permit(:content, :image).merge(user: current_user)
end

end