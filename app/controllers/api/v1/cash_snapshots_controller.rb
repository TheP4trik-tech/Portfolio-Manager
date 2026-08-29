class API::V1::CashSnapshotsController < ApplicationController
  def create
    @cash_snapshot = @cash_snapshot.new(permitted_params)
  end

  private
  def permitted_params
    params.require(:cash_snapshot).permit(:user_id, :total_balance, :available_cash, :total_investments, :profit_loss, :currency)
  end
end
