class ApiCredential < ApplicationRecord
  encrypts :api_key
  encrypts :api_id
  validates :provider, presence: true
  belongs_to :user

end
