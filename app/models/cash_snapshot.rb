class CashSnapshot < ApplicationRecord
  belongs_to :user
  validates :user, :currency, :total_balance, :available_cash, :total_investments, :profit_loss, presence: true
  validates :total_balance, :total_investments, :available_cash, numericality: { greater_than_or_equal_to: 0 }
end
