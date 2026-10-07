class StockSnapshot < ApplicationRecord
  belongs_to :user
  has_many :stocks, dependent: :destroy
  validates :currency, :stock_broker, :total_value, presence: true
  validates :total_value, numericality: { greater_than_or_equal_to: 0 }

  scope :chronological, -> { order(created_at: :desc) }
end
