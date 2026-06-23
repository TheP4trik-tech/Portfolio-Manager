class CashSnapshotService
  def initialize(user)
    @user = user
  end
  def call
    error_count = 0
    begin
        data = EurConverter.new(@user).call
        if data.values.any?(nil) || (data[:total_balance] == 0)
          raise "Error in EurConverter"
        end

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
      rescue => e
        error_count += 1
        if error_count > 3
          Rails.logger.error "Error in CashSnapshotService: #{e.message}"
        else
          sleep(10)
          retry
        end
      end

      end
    end
