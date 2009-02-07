class Me

  cattr_accessor :now

  def self.reset
    self.now = nil
  end

end
