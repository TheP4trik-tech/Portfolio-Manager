class SyncPortfolioJob < ApplicationJob
  queue_as :default
  retry_on Net::OpenTimeout, attempts: 5, wait: :exponentially_longer
  ## periodic(15 min) job to sync users CashSnapshots
  def perform
    User.all.each do |user|
      CashSnapshotService.new(user).call
    end
  end
end
