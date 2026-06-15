class SyncPortfolioJob < ApplicationJob
  ## periodic(15 min) job to sync portfolioSyncPortfolioJob.perform_now
  def perform
    User.all.each do |user|
      CashSnapshotService.new(user).call
    end
  end
end
