class Trading212Adapter
  attr_reader :data
  def initialize(user)
    @user = user
    @credential = @user.api_credentials.find_by(provider: "trading212")
    @data = fetch_data
  end
  def fetch_data
    conn = Faraday.new('https://live.trading212.com') do |f|
      f.request :authorization, 'Basic', Base64.strict_encode64("#{@credential.api_id}:#{@credential.api_key}")
      f.request :url_encoded
      f.response :json
    end
    response =  conn.get('/api/v0/equity/account/summary')
    equity_summary = response.body
    # returning hash for eur_converter service
    {
      total_value: equity_summary["totalValue"],
      free_cash: equity_summary["cash"]["availableToTrade"],
      unrealized_profit_loss: equity_summary["investments"]["unrealizedProfitLoss"],
      realized_profit_loss: equity_summary["investments"]["realizedProfitLoss"],
      currency: equity_summary["currency"]
    }

  end

end

