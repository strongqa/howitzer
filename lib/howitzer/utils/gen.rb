module Gen
  extend self

  def serial
    a = [('a'..'z').to_a, (0..9).to_a].flatten.shuffle
    "#{Time.now.utc.strftime("%j%H%M%S")}#{a[0..4].join}"
  end
end