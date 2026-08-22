class ApiCredential < ApplicationRecord
  encrypts :api_key
  encrypts :api_id
  validates :provider, presence: true
  before_validation :validate_presence
  belongs_to :user

  def validate_presence
    if self.api_key.blank? or self.api_id.blank?
      self.errors.add :base, "Api Key/ID can't be blank"
    end
  end
end
