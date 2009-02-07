class Local::User
  is_a_neo_node :with_meta_info => true

  property :name, :password
  index :name

  property :last_action, :type => Hash
  property :last_action_at, :type => DateTime


  def is_me_now
    Me.now = self
  end

  def self.valid_login?(name, password)
    matches = Local::User.find(:name => name)
    if matches.size == 1 && matches[0].password == password
      matches[0]
    else
      false
    end
  end

  # me.traverse.outgoing(:friends,:projects).depth(:all).filter {|tp| ... }
  # has_n()
  # has_n(:creations).relation(Sys::Priv::Creation)
  # has_n(:visibles).relation(Sys::Priv::Visibility)
  # has_n(:changeables).relation(Sys::Priv::Changebility)
#  has_n(:changeables).relation(Sys::Priv::Changebility)


end
