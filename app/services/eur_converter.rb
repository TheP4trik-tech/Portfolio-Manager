class EurConverter
  attr_reader :data
  def initialize(user)
   @user = user
   @users_brokers = @user.api_credentials.pluck(:provider)
  end

  # Makes sum of all eur converted data from brokers, returning hash for CashSnapshot service
  def call
      converted_portfolios  = convert_to_eur
      total_balance, available_cash, total_investments, profit_loss = 0, 0, 0, 0
      converted_portfolios.each do |portfolio|
        total_balance += portfolio[:total_balance]
        available_cash += portfolio[:available_cash]
        total_investments += portfolio[:total_investments]
        profit_loss  += portfolio[:profit_loss]
      end
      data =
      {
        user: @user,
        currency: "EUR",
        total_balance: total_balance,
        available_cash: available_cash,
        total_investments: total_investments,
        profit_loss: profit_loss
      }
  end

  private
  # Builds users broker adapters
  def build_adapters
    user_brokers_array = Array.new
    @users_brokers.each do |broker|
      case broker
      when "etoro"
        adapter = EtoroAdapter.new(@user)
        user_brokers_array << adapter
      when "trading212"
        adapter = Trading212Adapter.new(@user)
        user_brokers_array << adapter
      else
        raise "Broker not supported or wrong credentials"
      end
    end
    user_brokers_array
  end

  # gets currency EUR currency rate to users broker currency
  def fetch_currency(currency)
    adapter_currency = currency
    connection = Faraday.new("https://api.frankfurter.dev") do |f|
      f.request :url_encoded
      f.response :json
      f.response :raise_error
    end
    currency_endpoint = connection.get("/v2/rates")
    currency_rates = currency_endpoint.body

    currency_rate = currency_rates.find { |c| c["quote"] == adapter_currency }["rate"]
  end

  ## converts all user's adapters into EUR
  def convert_to_eur
    converted_portfolios =  build_adapters.map do |adapter|
      adapter_data = adapter.call
      currency_rate = fetch_currency(adapter_data[:currency])
      {
        total_balance: adapter_data[:total_balance] / currency_rate,
        available_cash: adapter_data[:available_cash] / currency_rate,
        total_investments: adapter_data[:total_investments] / currency_rate,
        profit_loss: adapter_data[:profit_loss] / currency_rate,
        currency: "EUR"
      }
    end
  end
end
