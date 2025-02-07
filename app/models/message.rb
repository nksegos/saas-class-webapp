class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates :body, presence: true
  after_create :broadcast_message

  def broadcast_message
    broadcast_append_to([conversation, "messages"], target: "messages", partial: "messages/message", locals: { message: self})
  end

end
