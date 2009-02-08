require 'digest/sha1'

class Local::User
  is_a_neo_node :with_meta_info => true

  property :name, :encrypted_password, :salt_for_password 
  property :password # needed for Local::User.value_object.new, attr_accessors owerwritten
  index :name

  property :last_action, :type => String
  property :last_action_at, :type => DateTime

  def is_me_now
    Me.now = self
  end

  def self.by_credentials(name, password)
    user_by_name = find_first(:name => name)
    if user_by_name && user_by_name.has_password?(password)
      user_by_name
    else
      false
    end
  end

  # setter for encrypted password
  def password=(password)
    @password = password.to_s.strip
    return if @password.blank?
    self.salt_for_password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{rand.to_s}--")
    self.encrypted_password = self.class.encrypt_password(self.salt_for_password, @password)
  end

  def password; nil; end

  # build encrypted password
  def self.encrypt_password(salt, password) # :nodoc:
    Digest::SHA1.hexdigest("#{salt}#{password}#{salt}")
  end

  def has_password?(password)
    encrypted_password == self.class.encrypt_password(salt_for_password, password)
  end

end


  # me.traverse.outgoing(:friends,:projects).depth(:all).filter {|tp| ... }
  # has_n()
  # has_n(:creations).relation(Sys::Priv::Creation)
  # has_n(:visibles).relation(Sys::Priv::Visibility)
  # has_n(:changeables).relation(Sys::Priv::Changebility)
#  has_n(:changeables).relation(Sys::Priv::Changebility)
