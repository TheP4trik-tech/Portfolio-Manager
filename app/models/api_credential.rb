class ApiCredential < ApplicationRecord
  encrypts :api_key
  encrypts :api_id
  validates :provider, presence: true
  before_validation :validate_presence
  belongs_to :user
  before_save :reset_error_sent

  def validate_presence
    if self.api_key.blank? or self.api_id.blank?
      self.errors.add :base, "Api Key/ID can't be blank"
    end
  end
  private
  def reset_error_sent
    if self.will_save_change_to_api_id? || self.will_save_change_to_api_key?
      self.error_sent = false
    end
  end
end
