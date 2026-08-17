class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :api_credentials, dependent: :destroy
  has_many :cash_snapshots, dependent: :destroy
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :first_name, presence: true, length: 2..25
  validates :last_name, length: 1..25, allow_blank: true


  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(first_name: data["name"],
           email: data["email"],
           password: Devise.friendly_token[0, 20]
        )
    end
    user
  end
end
