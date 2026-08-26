class EurConverter
  def initialize(user)
   @user = user
  end

  ADAPTERS =  {
    "etoro" => EtoroAdapter,
    "trading212" => Trading212Adapter
  }

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
      @data =
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
      adapters = []
      @user.api_credentials.pluck(:provider).each do |provider|
        if ADAPTERS[provider]
          adapters << ADAPTERS[provider].new(@user)
        else
          Rails.logger.error "Unknown broker #{provider}, please choose only supported brokers"
        end
      end
      adapters
  end

  # gets currency EUR currency rate to users broker currency
  def fetch_currency(currency)
    adapter_currency = currency
    connection = Faraday.new("https://api.frankfurter.dev") do |f|
      f.request :url_encoded
      f.response :json
      f.response :raise_error
      f.options.timeout =  10
      f.options.open_timeout = 10 ## 10 sec timeout for connection
      f.request :retry, max: 3, exceptions: [ Faraday::ConnectionFailed, Faraday::TimeoutError ]
      ## retrying on only meaningful errors
    end
    currency_endpoint = connection.get("/v2/rates")
    currency_rates = currency_endpoint.body

    currency_rate = currency_rates.find { |c| c["quote"] == adapter_currency }["rate"]
  end

  ## converts all user's adapters into EUR
  def convert_to_eur
    converted_portfolios =  build_adapters.map do |adapter|
      adapter_data = adapter.call

      ## if any of adapters has errors, eur_converter will not continue and set error_sent to true
      # which will sent user Email about his error
      if adapter_data.is_a?(String)
        provider = ADAPTERS.invert[adapter.class]
        failed_credential = @user.api_credentials.find_by(provider: provider)
        if failed_credential && !failed_credential.error_sent?
          failed_credential.update(error_sent: true)
          PortfolioMailer.with(user: @user, provider: @provider, error_message: adapter_data).error_mail.deliver_later
        end
        raise "Error occured in #{provider}: #{adapter_data}"
      end
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
