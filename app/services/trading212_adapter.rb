class Trading212Adapter
  attr_reader :data
  def initialize(user)
    @user = user
    @credentials = @user.api_credentials.find_by(provider: "trading212")

  end
  def call
    conn = Faraday.new('https://live.trading212.com') do |f|
      f.request :authorization, 'Basic', Base64.strict_encode64("#{@credentials.api_id}:#{@credentials.api_key}")
      f.request :url_encoded
      f.response :json
    end
    response =  conn.get('/api/v0/equity/account/summary')
    equity_summary = response.body
    # returning hash for eur_converter service
    {
      total_balance: equity_summary["totalValue"],
      available_cash: equity_summary["cash"]["availableToTrade"],
      total_investments: equity_summary["investments"]["totalCost"],
      profit_loss: equity_summary["investments"]["unrealizedProfitLoss"],
      currency: equity_summary["currency"]
    }

  end

end

