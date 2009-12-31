class Me

  cattr_accessor :now

  def self.reset
    self.now = nil
  end

  def self.someone?
    now.is_a?(User)
  end

  def self.none?
    !someone?
  end

  def self.update_last_action(controller_request)
    now.update!(:last_action => controller_request.query_parameters, :last_action_at => DateTime.now)
  end


  # shorthand for some shell games
  if Rails.env.development?
    def Me.lars!
      User.first_node.is_me_now
    end
  end

end
