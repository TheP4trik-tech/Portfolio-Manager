class StockSnapshotsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    user_snapshots = @user.stock_snapshots
    @last_snapshot = user_snapshots.last
  end
end
