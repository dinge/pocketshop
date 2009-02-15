class Me

  cattr_accessor :now

  def self.reset
    self.now = nil
  end

  def self.someone?
    now.is_a?(Local::User)
  end

  def self.none?
    !someone?
  end

  def self.update_last_action(controller_request)
    now.update!(:last_action => controller_request.query_parameters, :last_action_at => DateTime.now)
  end


  # shorthand for some shell games
  if Rails.env == 'development'
    def Me.lars!
      Local::User.first_node.is_me_now
    end
  end

end


class Object
  def my
    Me.now
  end

  def count_my(what)
    my.send(what).to_a.size
  end

  def dump_my(what)
    my.send(what).to_a.inspect
  end

  def dump_my_names(what)
    my.send(what).map(&:name)
  end

  def dump_my_classes(what)
    my.send(what).map(&:class)
  end

end


