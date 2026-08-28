class PagesController < ApplicationController
  def docs
  end

  def demo
    @hourly_data = generate_fake_data.uniq { |s| s[:time] }
    @daily_data = @hourly_data.group_by { |s| Time.at(s[:time]) }
                              .map { |time, records| records.last }
  end

  private
    def generate_fake_data
      40.times.map do |i|
        {
          time: i.hours.ago.to_i,
          value: rand(1000..2000).to_f,
          profit_loss: rand(-100..500).to_f
        }
      end
  end
end
