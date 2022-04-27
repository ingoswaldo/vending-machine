module Loop
  def self.infinite
    continue = true
    continue = yield(continue) while continue
  end
end
