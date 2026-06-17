class SyncPortfolioJob < ApplicationJob
  queue_as :default
  ## periodic(15 min) job to sync users CashSnapshots
  def perform
    User.all.each do |user|
      CashSnapshotService.new(user).call
    end
  end
end
