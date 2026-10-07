class StockSnapshotsController < ApplicationController
  @user = current_user
  def index
    @latest_stock_snapshot = @user.stock_snapshots.last
    @pre_latest_stock_snapshot = @user.stock_snapshots.second_to_last
    @stocks = @latest_stock_snapshot.stocks
  end
end
