class DashboardController < ApplicationController
  def index
    raw_snapshots = current_user.cash_snapshots
                                .order(:created_at)
                                .map { |s| { time: s.created_at.to_i, value: s.total_balance.to_f } }
                                .uniq { |s| s[:time] }

    @hourly_data = raw_snapshots.select { |s| s[:time] >= 7.days.ago.to_i }
    @daily_history = raw_snapshots
      .group_by { |s| Time.at(s[:time]).to_date }
      .map { |_, records| records.last }


  end
end
