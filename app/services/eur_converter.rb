class EurConverter
  def initialize
    @response =  Trading212Adapter.new(User.first)
  end

  def convert
    @response.data.map do |item|

    end


  end


end