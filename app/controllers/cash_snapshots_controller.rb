class CashSnapshotsController < ApplicationController
  def create
    @cash_snapshot = CashSnapshot.new(cash_snapshot_params)
    respond_to do |format|
      if @cash_snapshot.save

      end
    end
  end

  private
  def cash_snapshot_params
    params.require(:cash_snapshot).permit(:user_id, :total_balance, :available_cash, :total_investments, :profit_loss, :currency)
  end
end
