# This module describes data generator
module Gen
  def serial
    a = [('a'..'z').to_a, (0..9).to_a].flatten.shuffle
    "#{Time.now.utc.strftime('%j%H%M%S')}#{a[0..4].join}"
  end

  module_function :serial
end
