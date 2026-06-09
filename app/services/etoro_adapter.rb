class EtoroAdapter
  def initialize(user)
    @user = user
    @credentials = @user.api_credentials.find_by(provider: "etoro")
  end

  def call
    ## Creating api connection
    conn = Faraday.new('https://public-api.etoro.com') do |f|
    f.headers['x-request-id'] = SecureRandom.uuid
    f.headers['x-api-key'] = @credentials.api_id
    f.headers['x-user-key'] = @credentials.api_key
    f.request :url_encoded
    f.response :json
    end

    ## Getting response
    response = conn.get('/api/v1/trading/info/real/pnl')
    equity_summary = response.body["clientPortfolio"]

    {
      total_balance: equity_summary["credit"],
      available_cash: calculate_available_cash(equity_summary),
      total_investments:  calculate_total_investments(equity_summary),
      profit_loss: equity_summary["unrealizedPnL"],
      currency: "USD"
    }

  end

  def calculate_available_cash(equity_summary)
    ## formula "https://api-portal.etoro.com/guides/calculate-available-cash"
    credit = equity_summary["credit"]
    orders = calculate_orders(equity_summary)

    available_cash = credit - (orders[:orders_for_open_total] + orders[:orders_total])



  end

  def calculate_total_investments(equity_summary)
    ## formula "https://api-portal.etoro.com/guides/calculate-total-invested"

    positions_total = calculate_positions_total(equity_summary)
    mirrors = calculate_mirrors(equity_summary)
    orders = calculate_orders(equity_summary)

    total_investments =
      positions_total + mirrors[:positions_total] +
      (mirrors[:available_cash] - mirrors[:closed_profit]) +
      orders[:orders_for_open_total] + orders[:orders_total] +
      orders[:orders_for_open_external_cost_total]

  end

  def calculate_positions_total(equity_summary)
    positions_total = 0
    positions = equity_summary["positions"]
    positions.each do |position|
      positions_total += position["amount"]
    end
    positions_total
  end

  def calculate_mirrors(equity_summary)
    mirrors_positions_total = 0
    mirrors_available_cash_total = 0
    mirrors_closed_positions_net_profit_total = 0

    mirrors = equity_summary["mirrors"]

    mirrors.each do |mirror|
      mirrors_available_cash_total += mirror["availableAmount"]
      mirrors_closed_positions_net_profit_total += mirror["closedPositionsNetProfit"]

      mirror_positions = mirror["positions"]

      mirror_positions.each do |position|
        mirrors_positions_total += position["amount"]
      end
    end
    {
      positions_total: mirrors_positions_total,
      available_cash: mirrors_available_cash_total,
      closed_profit: mirrors_closed_positions_net_profit_total
    }
  end

  def calculate_orders(equity_summary)
    orders_total = 0
    orders_for_open_total = 0
    orders_for_open_external_cost_total = 0

    orders_for_open = equity_summary["ordersForOpen"]

    orders_for_open.each do |order|
      if order["mirrorID"] == 0
        orders_for_open_total += order["amount"]
        orders_for_open_external_cost_total += order["totalExternalCosts"]
      end
    end

    orders = equity_summary["orders"]
      orders.each do |order|
        orders_total += order["amount"]
      end
    {
      orders_total: orders_total,
      orders_for_open_total: orders_for_open_total,
      orders_for_open_external_cost_total: orders_for_open_external_cost_total
    }

  end


end