class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :posts, dependent: :destroy

  has_many :contacts, dependent: :destroy
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name            
      user.password = Devise.friendly_token[0, 20]
    end
  end

end


