class Local::User
  is_a_neo_node do
    options.meta_info = true
    options.validations = true
  end

  property :name, :encrypted_password, :salt_for_password
  property :password # needed for Local::User.value_object.new, attr_accessors owerwritten
  def password; nil; end

  index :name

  property :last_action, :type => String
  property :last_action_at, :type => DateTime

  has_n(:created_tags).to(Tag).relation(Acl::Created)
  has_n(:created_things).to(Thing).relation(Acl::Created)
  has_n(:created_concepts).to(Concept).relation(Acl::Created)

  # has_n(:creations).relation(Acl::Creation)

  def is_me_now
    Me.now = self
  end

  def self.by_credentials(name, password)
    user_by_name = find_first(:name => name)
    if user_by_name && user_by_name.has_this_password?(password)
      user_by_name
    else
      false
    end
  end

  # attr_writer for encrypted password
  def password=(password)
    @password = password.to_s.strip
    return if @password.blank?
    self.salt_for_password = self.class.generate_salt
    self.encrypted_password = self.class.encrypt_password_with_salt(@password, self.salt_for_password)
  end

  # build encrypted password
  def self.encrypt_password_with_salt(password, salt)
    Digest::SHA1.hexdigest("#{salt}#{password}#{salt}")
  end

  def self.generate_salt
    Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{rand.to_s}--")
  end

  def has_this_password?(password)
    encrypted_password == self.class.encrypt_password_with_salt(password, salt_for_password)
  end

end

  # me.traverse.outgoing(:friends,:projects).depth(:all).filter {|tp| ... }
  # has_n()
  # has_n(:creations).relation(Sys::Priv::Creation)
  # has_n(:visibles).relation(Sys::Priv::Visibility)
  # has_n(:changeables).relation(Sys::Priv::Changebility)
#  has_n(:changeables).relation(Sys::Priv::Changebility)
