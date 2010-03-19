require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }

  describe "some instance methods" do
    before(:each) do
      Neo4j::Transaction.run do 
        @user = User.new(:name => 'harras', :password => 'lkwpeter')
      end
    end

    it "calling is_me_now should set Me.now to the calling user" do
      @user.is_me_now
      Me.now.should be @user
    end
  end



  describe "the authentification" do

    before(:all) do
      Neo4j::Transaction.run do
        @user = User.new(:name => 'harras')
        @user.password = 'lkwpeter'
      end
    end

    context "with valid credentials" do
      it "should succeed and return the user object" do
        user = User.by_credentials('harras', 'lkwpeter')
        user.name.should == @user.name
      end
    end

    context "with invalid credentials" do
      it "should fail" do
        user = User.by_credentials('badboy', 'haxor')
        user.should be false
      end

      it "should fail given only a valid password" do
        user = User.by_credentials('badboy', 'lkwpeter')
        user.should be false
      end

      it "should fail given only a valid name" do
        user = User.by_credentials('harras', 'haxor')
        user.should be false
      end
    end



    describe "the password authorization" do
      context "given an valid password" do
        it "should succeed" do
          @user.has_this_password?('lkwpeter').should be_true
        end
      end

      context "given an invalid password" do
        it "should fail" do
          @user.has_this_password?('wrong password').should be_false
        end
      end
    end
  end



  describe "the password and salt" do

    before(:all) do
      @encrypted_password = User.encrypt_password_with_salt('password', 'salt')
    end

    describe "the encrypted password" do
      it "should be a hexdigest with 40 chars length" do
        @encrypted_password.should be_instance_of(String)
        @encrypted_password.size.should be 40
      end

      it "should by exactly be the given string" do
        @encrypted_password.should == '0698f86248c9592589005ba8b7f1e2e9383964cf'
      end
    end

    describe "the plain text password" do
      it "should be not available for security purposes" do
        Neo4j::Transaction.run do 
          user = User.new(:name => 'harras', :password => 'lkwpeter')
          user.password.should be_nil
        end
      end
    end

    describe "the salt" do
      it "should be a hexdigest with 40 chars length" do
        first_salt = User.generate_salt
        first_salt.should be_instance_of(String)
        first_salt.size.should be 64
      end

      it "should be a random uniq value" do
        salts = (0..100).map{ User.generate_salt }
        salts.uniq.should == salts
      end
    end

    describe "setting up" do

      before(:each) do
        Neo4j::Transaction.new 
        @user = User.new(:name => 'sugar')
      end

      after(:each) { Neo4j::Transaction.finish }

      context "before" do
        context "the password" do
          it "should be undefined" do
            @user.encrypted_password.should be nil
          end
        end

        context "the salt" do
          it "should be undefined" do
            @user.salt_for_password.should be nil
          end
        end
      end

      context "after" do
        before(:each) do
          @user.password = 'totaly wired'
        end

        context "the password" do
          it "should be defined" do
            @user.encrypted_password.should be_instance_of(String)
            @user.encrypted_password.size.should be 40
          end

          it "should not be like the salt" do
            @user.encrypted_password.should_not == @user.salt_for_password
          end
        end

        context "the salt" do
          it "should be defined" do
            @user.salt_for_password.should be_instance_of(String)
            @user.salt_for_password.size.should be 64
          end
        end
      end

    end

  end
end
