class EtoroStocksService
  def initialize(user)
    @user = user
  end

  def call
    provider = @user.api_credentials.find_by(provider: "etoro")
    if  @credentials.api_id.nil? || @credentials.api_key.nil?
      raise "Etoro credentials not provided"
    end
    conn = Faraday.new("https://public-api.etoro.com/api/v1/trading/info/portfolio") do |f|
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

  def parse_etoro_response(response)
    stocks = response.body["clientPortfolio"]["positions"]
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
