class EtoroStockJob < ApplicationJob
  queue_as :default
  retry_on Net::OpenTimeout, Faraday::Error, attempts: 5, wait: :exponentially_longer

  def perform
    User.joins(:api_credentials).where(api_credentials: { provider: "etoro" }).distinct.find_each do |user|
      EtoroStocksService.new(user).call
    end
  end
end
