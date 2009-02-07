class Me

  cattr_accessor :now

  def self.reset
    self.now = nil
  end

  def self.someone?
    now.is_a?(Local::User)
  end
  
  def self.name
    now.name
  end
  
end
