class CashSnapshotService
  def initialize(user)
    @user = user
  end

  def call
    data = EurConverter.new(@user).call

    CashSnapshot.create!(
      user: @user,
      total_balance: data[:total_balance],
      available_cash: data[:available_cash],
      total_investments: data[:total_investments],
      profit_loss: data[:profit_loss],
      currency: data[:currency]
    )
  rescue => e
    Rails.logger.error "Error in CashSnapshotService for user #{@user.id}: #{e.message}"
    raise
  end
end
