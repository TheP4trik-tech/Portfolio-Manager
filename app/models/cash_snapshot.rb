class CashSnapshot < ApplicationRecord
  belongs_to :user
  validates :currency, presence: true
  validates :total_value, presence: true
  validates :free_cash, presence: true
  validates :user_id, presence: true
  validates :currency, uniqueness: { scope: :user_id }
end
