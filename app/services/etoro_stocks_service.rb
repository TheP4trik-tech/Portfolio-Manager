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
        ## this will be filled in get_stock_info
        instrument_id: stock["instrumentID"],
        invested_amount: stock["initialAmountInDollars"],
        units: stock["units"],
        currency: "USD", ## default currency for Etoro
        name: "" ## in case of Etoro we don't have stock name, we have to make another API call later to get that
      }
    end
    end
  end

  ## Etoro does not provide all information about sotkcs in portfolio request,
  ## so we have to make another connection and match Stock IDs in order to get individual stock data taht we couldnt get before
  def get_stock_info(user_portfolio_stocks)
    stocks = user_portfolio_stocks
    instrument_ids = stocks.map { |stock| stock[:instrument_id] }.uniq

    begin
      ## Getting response with all instrument data we need to fill
      response = etoro_api_connection.get("/api/v1/market-data/instruments")
    rescue Faraday::Error => e
      if e.response[:status] == 401
        raise "Invalid credentials"
      else
        raise e
      end
    end
    instruments = response.body["instrumentDisplayDatas"]


    begin
      ## Getting bulk all rates for instruments to calculate profit
      rates_response = etoro_api_connection.get("/api/v1/market-data/instruments/rates", { instrumentIds: instrument_ids.join(",") })
    rescue Faraday::Error => e
      if e.response[:status] == 401
        raise "Invalid credentials"
      else
        raise e
      end
    end
    rates = rates_response.body["rates"]
    if rates.blank? || instruments.blank?
      raise "No rates or instruments returned from eToro API"
    end
    stocks.map do |stock|
      instrument = instruments.find { |instrument| instrument["instrumentID"] == stock[:instrument_id] }

      rate_info = rates.find { |rate| rate["instrumentID"] == stock[:instrument_id] }


      market_rate = rate_info["bid"] ## current market pice
      icon_uri = instrument.dig("images", 0, "uri")
      calculated_price = (stock[:units].to_f * market_rate.to_f).round(2) # total value held in stock
      ## final stock blueprint to be sent into database
      {
        price: calculated_price,
        instrument_id: stock[:instrument_id],
        currency: stock[:currency],
        units: stock[:units],
        invested_amount: stock[:invested_amount],
        name: instrument["instrumentDisplayName"],
        icon_uri: icon_uri
      }
    end
    end



  def create_stock_snapshot(user_stocks_with_names)
    stocks = user_stocks_with_names
    sum = stocks.sum { |stock| stock[:price] }

    stock_snapshot = StockSnapshot.create!(total_value: sum, currency: "USD", user: @user, stock_broker: "etoro")
    ## Stock snapshot holds total amount of all stocks combined, stocks are binded via reference with this object
    timestamp = Time.current
    records = stocks.map do |stock|
      {

        name: stock[:name],
        price: stock[:price],
        currency: stock[:currency],
        units: stock[:units],
        invested_amount: stock[:invested_amount],
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
