class CashSnapshot < ApplicationRecord
  belongs_to :user
  validates :user, :currency, :total_balance, :available_cash, :total_investments, :profit_loss, presence: true
end
