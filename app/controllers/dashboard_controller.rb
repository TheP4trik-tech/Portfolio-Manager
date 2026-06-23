class DashboardController < ApplicationController
  def index
    @snapshots = current_user.cash_snapshots
                             .order(:created_at)
                             .map { |s| { time: s.created_at.to_i, value: s.total_balance.to_f } }
                             .uniq { |s| s[:time] }

  end
end
