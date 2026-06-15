class CashSnapshot < ApplicationRecord
  belongs_to :user, dependent: :destroy
  validates :user, :currency, :total_balance, :available_cash, :total_investments, :profit_loss, presence: true
end
