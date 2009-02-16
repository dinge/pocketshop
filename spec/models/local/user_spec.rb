require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Local::User do

  before(:all) do
    start_neo4j
    @user = Local::User.new(:name => 'harras', :password => 'lkwpeter')
  end

  after(:all) do
    stop_neo4j
  end


  it "Me.now should be the user calling is_me_now" do
    @user.is_me_now
    Me.now.should be @user
  end

  it "should return user object on valid credentials" do
    user = Local::User.by_credentials('harras', 'lkwpeter')
    user.name.should == @user.name
  end

  it "should return false with valid name and invalid password" do
    user = Local::User.by_credentials('harras', 'haxor')
    user.should be false
  end

  it "should return false with invalid name and valid password" do
    user = Local::User.by_credentials('badboy', 'lkwpeter')
    user.should be false
  end

  it "should return false on invalid credentials" do
    user = Local::User.by_credentials('badboy', 'haxor')
    user.should be false
  end

  it "should return nil calling password even for valid users" do
    @user.password.should be nil
  end

  it "should return true calling has_this_password? with a valid password" do
    @user.has_this_password?('lkwpeter').should be true
  end

  it "should return false calling has_this_password? with a invalid password" do
    @user.has_this_password?('wrong password').should be false
  end

  it "should retrun an encrypted password calling encrypt_password" do
    Local::User.encrypt_password('salz', 'suppe').should == '5f1b1ff4df882ba210abb11fc49585cb68f8f23b'
  end

  it "should set property encrypt_password and salt_for_password calling password=" do
    user = Local::User.new(:name => 'sugar')
    user.encrypted_password.should be nil
    user.salt_for_password.should be nil
    user.password = 'totaly wired'
    user.encrypted_password.should be_instance_of(String)
    user.encrypted_password.size.should be 40
    user.salt_for_password.should be_instance_of(String)
    user.salt_for_password.size.should be 40
    user.encrypted_password.should_not == user.salt_for_password
  end

  it "should generate an random uniq salt" do
    first_salt = Local::User.generate_salt
    second_salt = Local::User.generate_salt
    first_salt.should be_instance_of(String)
    first_salt.size.should be 40
    first_salt.should_not == second_salt
  end

end
