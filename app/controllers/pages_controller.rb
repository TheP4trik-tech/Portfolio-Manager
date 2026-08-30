class PagesController < ApplicationController
  def docs
  end

  def demo
    @hourly_data = generate_hourly_data
    @daily_data  = generate_daily_data

    last_item = @hourly_data.last

    @latest_snapshot = {
      total_balance: last_item[:value],
      profit_loss: last_item[:profit_loss],
      total_investments: (last_item[:value] * 0.7).round(2),
      available_cash: (last_item[:value] * 0.3).round(2)
    }
  end

  private

  def generate_hourly_data
    current_value = 1500.0
    base_value = 1500.0

    (1..24).map do |i|
      current_value += rand(-10.0..15.0)

      {
        time: (25 - i).hours.ago.to_i,
        value: current_value.round(2),
        profit_loss: (current_value - base_value).round(2)
      }
    end
  end

  def generate_daily_data
    current_value = 1000.0
    base_value = 1000.0

    (1..30).map do |i|
      current_value += rand(-30.0..40.0)

      {
        time: (31 - i).days.ago.to_i,
        value: current_value.round(2),
        profit_loss: (current_value - base_value).round(2)
      }
    end
  end
end
