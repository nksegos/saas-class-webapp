class ConversationsController < ApplicationController
  before_action :authenticate_user!

  # List conversations for the current user
  def index
    @conversations = current_user.conversations.includes(:users, :messages)
  end

  # Show a single conversation
  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order(created_at: :asc)
  end

  # Create a new conversation (private or group)
  def create
    # Expect params[:user_ids] to be an array of user IDs
    # For private messages, this might include only one other user.
    participant_ids = params[:user_ids] || []
    # Always include the current user
    participant_ids << current_user.id

    # For simplicity, find an existing conversation with the same participants
    @conversation = Conversation.joins(:conversation_users)
      .where(conversation_users: { user_id: participant_ids.uniq })
      .group('conversations.id')
      .having("COUNT(conversation_users.id) = ?", participant_ids.uniq.count)
      .first

    unless @conversation
      # Create a new conversation (set conversation_type as needed)
      conversation_type = participant_ids.uniq.count > 2 ? "group" : "private"
      @conversation = Conversation.create(conversation_type: conversation_type)
      participant_ids.uniq.each do |uid|
        @conversation.conversation_users.create(user_id: uid)
      end
    end

    respond_to do |format|
      format.html { redirect_to conversation_path(@conversation) }
      format.js   # For AJAX-based popup creation if needed
    end
  end
end

