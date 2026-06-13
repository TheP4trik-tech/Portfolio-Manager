class CashSnapshotService

  def initialize(user)
    @user = user
  end
  def call
    begin
      data = EurConverter.new(@user).call
      CashSnapshot.create!(user: @user,
                           total_balance: data[:total_balance],
                           available_cash: data[:available_cash],
                           total_investments: data[:total_investments],
                           profit_loss: data[:profit_loss],
                           currency: data[:currency])
    rescue Faraday::Error => e
      Rails.logger.error "Faraday error: #{e.message}"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "ActiveRecord error: #{e.message}"
    end
  end

end