class ApiCredential < ApplicationRecord
  encrypts :api_key, presence: true, length: 6..128
  encrypts :api_id, presence: true, length: 6..128
  validates :provider, presence: true
  belongs_to :user
end
