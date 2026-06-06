class User < ApplicationRecord
  has_many :api_credentials, dependent: :destroy
  has_many :cash_snapshots, dependent: :destroy
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :name, :surname, presence: true, length: 2..25
end
