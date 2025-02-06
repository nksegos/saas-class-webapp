class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user
    if @message.save
      # Optionally, broadcast with Action Cable for real-time updates.
      respond_to do |format|
        format.js   # create.js.erb will update the conversation modal
        format.html { redirect_to conversation_path(@conversation) }
      end
    else
      # Handle errors (for simplicity, redirect back)
      redirect_to conversation_path(@conversation), alert: "Message not sent."
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end

