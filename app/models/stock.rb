class Stock < ApplicationRecord
  belongs_to :stock_snapshot
  validates :name, :price, :icon_uri, :stock_id, :currency, :invested_amount, presence: true

  validates :price, :invested_amount, :amount, numericality: { greater_than_or_equal_to: 0 }

  def profit_loss
    (price.to_f - invested_amount.to_f).round(2)
  end

  # Percentage profiloss
  def profit_loss_percentage
    return 0.0 if invested_amount.to_f <= 0

    ((profit_loss / invested_amount.to_f) * 100).round(2)
  end

  #  Helper method to be used in view
  def profitable?
    profit_loss >= 0
  end
end
