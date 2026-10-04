class EtoroStocksService
  def initialize(user)
    @user = user
    @credentials = @user.api_credentials.find_by(provider: "etoro")
  end

  def call
  end
  def etoro_api_connection
    if  @credentials.api_id.nil? || @credentials.api_key.nil?
      raise "Etoro credentials not provided"
    end
    conn = Faraday.new("https://public-api.etoro.com") do |f|
      f.headers["x-request-id"] = SecureRandom.uuid ## Needed to make Etoro request
      f.headers["x-api-key"] = @credentials.api_id
      f.headers["x-user-key"] = @credentials.api_key
      f.request :url_encoded
      f.response :json
      f.response :raise_error
      f.options.timeout =  10
      f.options.open_timeout = 10 ## 10 sec timeout for connection
      f.request :retry, max: 3, exceptions: [ Faraday::ConnectionFailed, Faraday::TimeoutError ]
      ## retrying on only meaningful errors
    end
  end

  def get_portfolio_stocks
    begin
      ## Getting response
      response = etoro_api_connection.get("api/v1/trading/info/portfolio")
    rescue Faraday::Error => e
      if e.response[:status] == 401
        return "Invalid credentials"
      else
        return  e.response
      end
    end
    portfolio = response.body["portfolio"]
    if portfolio.blank? || portfolio["positions"].blank?
      raise "No positions in portfolio"
    end
    stocks = portfolio["positions"]
    if stocks.present? ## not necesarry there, but rails editor warned me and i cant live with this :D
    stocks.map do |stock|
      {
        price: stock["initialAmountInDollars"],
        stock_id: stock["instrumentID"],
        currency: "USD", ## default currency for Etoro
        name: "" ## in case of Etoro we don't have stock name, we have to make another API call later to get that
      }
    end
    end
  end

  def get_stock_info
    begin
      ## Getting response
      response = etoro_api_connection.get("/api/v1/market-data/instruments")
    rescue Faraday::Error => e
      if e.response[:status] == 401
        return "Invalid credentials"
      else
        return  e.response
      end
    end
    instruments = response.body["instruments"]
    if instruments.blank? || instruments["positions"].blank?
      raise "No instruments in response"
    end
    stocks = get_portfolio_stocks
    stocks.map do |stock|
      instrument = instruments.find { |instrument| instrument["id"] == stock[:stock_id] }
      {
        price: stock[:price],
        stock_id: stock[:stock_id],
        currency: instrument["currency"],
        name: instrument["name"]
      }
    end
  end
end
