class PagesController < ApplicationController
  def docs
  end

  def demo
    demo_data = Rails.cache.fetch("demo_chart_data", expires_in: 1.day) do
      build_demo_dataset
    end
    @hourly_data = demo_data[:hourly]
    @daily_data  = demo_data[:daily]
  end

  private


  ## generates data suited for lightweight chart demo, which will store in cache for all users
  def build_demo_dataset
    now = Time.current

    base_value = 1500.0
    current_value = base_value
    hourly = (0..168).to_a.reverse.map do |i|
      current_value += rand(-15.0..18.0)
      {
        time: (now - i.hours).to_i,
        value: current_value.round(2),
        profit_loss: (current_value - base_value).round(2)
      }
    end

    base_value = 1000.0
    current_value = base_value
    daily = (0..365).to_a.reverse.map do |i|
      current_value += rand(-40.0..50.0)
      {
        time: (now - i.days).to_i,
        value: current_value.round(2),
        profit_loss: (current_value - base_value).round(2)
      }
    end

    { hourly: hourly, daily: daily }
  end
end
