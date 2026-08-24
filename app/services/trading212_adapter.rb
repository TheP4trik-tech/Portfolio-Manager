class Trading212Adapter
  def initialize(user)
    @user = user
    @credentials = @user.api_credentials.find_by(provider: "trading212")
  end
  def call
    if @credentials.api_id.nil? || @credentials.api_key.nil?
      raise "Trading 212 credentials not provided"
    end
    conn = Faraday.new("https://live.trading212.com") do |f|
      f.request :authorization, "Basic", Base64.strict_encode64("#{@credentials.api_id}:#{@credentials.api_key}")
      ## Trading212 requires Base64 for each connection
      f.request :url_encoded
      f.response :json
      f.response :raise_error
      f.options.timeout =  10
      f.options.open_timeout = 10 ## 10 sec timeout for connection
    end
    begin
    response =  conn.get("/api/v0/equity/account/summary")
    equity_summary = response.body
    # returning hash for eur_converter service
    {
      total_balance: equity_summary["totalValue"],
      available_cash: equity_summary["cash"]["availableToTrade"],
      total_investments: equity_summary["investments"]["totalCost"],
      profit_loss: equity_summary["investments"]["unrealizedProfitLoss"],
      currency: equity_summary["currency"]
    }
    rescue Faraday::Error => e
      if e.response[:status] == 401
        "Invalid credentials in Trading212"
      else
        e.response
      end
    end
  end
end
