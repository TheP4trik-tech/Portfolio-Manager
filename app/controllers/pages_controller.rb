class PagesController < ApplicationController
  def docs
  end
  def stocks_demo
    stocks = generate_demo_stocks

    @last_snapshot = StockSnapshot.new(
      created_at: 15.minutes.ago,
      total_value: stocks.sum(&:price).round(2),
      currency: "USD",
      stock_broker: "eToro"
    )

    @last_snapshot.stocks = stocks
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
  def generate_demo_stocks
    raw_data = [
      { name: "Apple Inc", units: 14.52, invested: 2500.0, price: 3325.08, icon: "https://etoro-cdn.etorostatic.com/market-avatars/1001/35x35.png" },
      { name: "Microsoft Corp", units: 6.21, invested: 2400.0, price: 2682.72, icon: "https://etoro-cdn.etorostatic.com/market-avatars/1002/35x35.png" },
      { name: "NVIDIA Corp", units: 18.45, invested: 1800.0, price: 2324.70, icon: "https://etoro-cdn.etorostatic.com/market-avatars/1050/35x35.png" },
      { name: "Amazon.com Inc", units: 8.75, invested: 1500.0, price: 1627.50, icon: "https://etoro-cdn.etorostatic.com/market-avatars/1005/35x35.png" },
      { name: "Alphabet Inc", units: 7.10, invested: 1200.0, price: 1292.20, icon: "https://etoro-cdn.etorostatic.com/market-avatars/1008/35x35.png" },
      { name: "Tesla Inc", units: 4.80, invested: 1100.0, price: 1056.00, icon: "https://etoro-cdn.etorostatic.com/market-avatars/1020/35x35.png" },
      { name: "Meta Platforms", units: 2.15, invested: 950.0, price: 1247.00, icon: "https://etoro-cdn.etorostatic.com/market-avatars/1012/35x35.png" },
      { name: "Caterpillar Inc", units: 1.82, invested: 700.0, price: 682.50, icon: "https://etoro-cdn.etorostatic.com/market-avatars/1035/35x35.png" },
      { name: "ASML Holding", units: 0.95, invested: 850.0, price: 798.00, icon: "https://etoro-cdn.etorostatic.com/market-avatars/4976/35x35.png" },
      { name: "Taiwan Semi", units: 3.40, invested: 500.0, price: 574.60, icon: "https://etoro-cdn.etorostatic.com/market-avatars/2007/35x35.png" }
    ]

    raw_data.map do |item|
      Stock.new(
        name: item[:name],
        units: item[:units],
        invested_amount: item[:invested],
        price: item[:price],
        icon_uri: item[:icon],
        currency: "USD"
      )
    end
  end
end
