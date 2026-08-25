class SyncPortfolioJob < ApplicationJob
  queue_as :default
  retry_on Net::OpenTimeout, Faraday::Error, attempts: 5, wait: :exponentially_longer
  ## periodic(15 min) job to sync users CashSnapshots
  def perform
    User.joins(:api_credentials).distinct.find_each do |user|
      CashSnapshotService.new(user).call
    rescue => e
       "Error occured with user #{user}, #{e}"
    end
  end
end
