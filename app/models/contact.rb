class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :contact, class_name: "User"

  validates :contact_id, uniqueness: { scope: :user_id }
end

