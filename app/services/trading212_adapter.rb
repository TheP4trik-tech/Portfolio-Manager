class ApiFetch
  def initialize(user)
    @user = user
    @credential = @user.api_credentials.find_by(provider: "trading212")
    fetch_data
  end
  def fetch_data
    conn = Faraday.new('https://live.trading212.com') do |f|
      f.request :authorization, 'Basic',
                Base64.strict_encode64("#{@credential.api_id}:#{@credential.api_key}")
      f.request :url_encoded
    end
    response =  conn.get('/api/v0/equity/account/summary')
    return response.body

  end

end

