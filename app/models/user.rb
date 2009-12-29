class User
  is_a_neo_node do
    db.meta_info true
    db.validations true
  end

  property :name, :tokenized => true, :analyzer => :keyword 
  property :encrypted_password, :salt_for_password
  property :password # needed for User.value_object.new, attr_accessors owerwritten, TODO: check if needed any longer
  def password; nil; end

  index :name

  property :last_action, :type => String
  property :last_action_at, :type => DateTime

  validates_presence_of :name, :password


  has_n(:created_tags).to(Tag).relationship(Acl::Created)
  has_n(:created_things).to(Thing).relationship(Acl::Created)
  has_n(:created_concepts).to(Concept).relationship(Acl::Created)
  has_n(:created_concept_values).to(Concept::Value).relationship(Acl::Created)
  has_n(:created_teams).to(Team).relationship(Acl::Created)
  has_n(:created_users).to(Team).relationship(Acl::Created)

  # has_n(:created_tool_phrase_makers).to(Tool::PhraseMaker).relationship(Acl::Created)
  has_n(:created_tools_phrase_maker_phrases).to(Tools::PhraseMaker::Phrase).relationship(Acl::Created)
  has_n(:created_tools_phrase_maker_triples).to(Tools::PhraseMaker::Triple).relationship(Acl::Created)


  has_one(:creator).from(User, :created_users)

  # has_n(:creations).relationship(Acl::Creation)

  def is_me_now
    Me.now = self
  end

  def self.by_credentials(name, password)
    return Neo4j::Transaction.run{ User.nodes.to_a.first }
    user_by_name = find_first(:name => name)
    if user_by_name && Neo4j::Transaction.run{ user_by_name.has_this_password?(password) }
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
