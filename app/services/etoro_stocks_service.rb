class EtoroStocksService
  def initialize(user)
    @user = user
    @credentials = @user.api_credentials.find_by(provider: "etoro")
  end

  def call
    portfolio_stocks = get_portfolio_stocks  ## retreive user stocks
    user_stocks_with_names = get_stock_info(portfolio_stocks) ## gets stock name and image uri
    create_stock_snapshot(user_stocks_with_names)  ## creates stocks snapshot with total sum of all stocks and creates individual stocks DB record
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
        raise "Invalid credentials"
      else
        return  e.response
      end
    end
    portfolio = response.body["clientPortfolio"]
    if portfolio.blank? || portfolio["positions"].blank?
         raise "No positions in portfolio"
    end
    stocks = portfolio["positions"]
    if stocks.present? ## not necesarry there, but rails editor warned me and i cant live with this :D
    stocks.map do |stock|
      {
        price: stock["initialAmountInDollars"],
        instrument_id: stock["instrumentID"],
        currency: "USD", ## default currency for Etoro
        name: "" ## in case of Etoro we don't have stock name, we have to make another API call later to get that
      }
    end
    end
  end

  ## Etoro does not provide stock name and icons in portfolio request,
  ## so we have to make another connection and match Stock IDs in order to get their informations
  def get_stock_info(user_portfolio_stocks)
    begin
      ## Getting response
      response = etoro_api_connection.get("/api/v1/market-data/instruments")
    rescue Faraday::Error => e
      if e.response[:status] == 401
        raise "Invalid credentials"
      else
        raise e
      end
    end
    instruments = response.body["instrumentDisplayDatas"]
    if instruments.blank?
      raise "No instruments in response"
    end
    stocks = user_portfolio_stocks
    stocks.map do |stock|
      instrument = instruments.find { |instrument| instrument["instrumentID"] == stock[:instrument_id] }
      icon_uri = instrument.dig("images", 0, "uri")
      {
        price: stock[:price],
        instrument_id: stock[:instrument_id],
        currency: stock[:currency],
        name: instrument["instrumentDisplayName"],
        icon_uri: icon_uri

      }
    end
  end

  def create_stock_snapshot(user_stocks_with_names)
    stocks = user_stocks_with_names
    sum = stocks.sum { |stock| stock[:price] }

    stock_snapshot = StockSnapshot.create!(total_value: sum, currency: "USD", user: @user, stock_broker: "etoro")
    timestamp = Time.current
    records = stocks.map do |stock|
      {

        name: stock[:name],
        price: stock[:price],
        currency: stock[:currency],
        instrument_id: stock[:instrument_id],
        icon_uri: stock[:icon_uri],
        stock_snapshot_id: stock_snapshot.id
      }
    end
    Stock.insert_all!(records) ## super fast insert, the data is from etoro so there is no SQL injection risk, all data
    rescue => e
      raise "Error in EtoroStocksService for user #{@user}: #{e.message}"
    end
end
