class Stock < ApplicationRecord
  belongs_to :stock_snapshot
  validates :name, :price, :icon_uri, :stock_id, :currency, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
