require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "a global uuid", 'is part of the things uri' do

  it "version 2 should be the default version" do
    DingDealer::Guid.version.should be 3
  end


  describe "encoding" do
    before(:all) do
      DingDealer::Guid.version = 1
    end

    context "a string" do
      it "should accept a string for encoding and return a string" do
        guid = DingDealer::Guid.new
        guid.encode('somestring').should be_a_kind_of(String)
      end

      it "should encode using it's class methods" do
        DingDealer::Guid.encode('somestring').should == 'gnirtsemosv1'
      end
    end

    context "a hash" do
      it "should accept a hash for encoding", 'by internally cnverting it to a json' do
        guid = DingDealer::Guid.new
        guid.encode(:a => 1, :b => 2).should == "2-b-1-av1"
      end

      it "should encode using it's class methods" do
        DingDealer::Guid.encode(:a => 1, :b => 2).should == "2-b-1-av1"
      end
    end
  end


  describe 'decoding' do
    before(:all) do
      DingDealer::Guid.version = 1
    end

    context "to a string" do
      it "should decode", 'no version number have to be given in decodable using the instance method, default is used' do
        guid = DingDealer::Guid.new
        guid.decode('gnirtsemos').should == 'somestring'
      end

      it "should decode using it's class methods", 'version number ist parsed' do
        DingDealer::Guid.decode('gnirtsemosv1') == 'somestring'
      end
    end

    context "to a hash" do
      it "should decode to a hash", 'no version number have to be given in decodable using the instance method, default is used' do
        guid = DingDealer::Guid.new
        decoded = guid.decode_to_hash( "2-b-1-a" )
        decoded.should == {'a' => '1', 'b' => '2'}
        decoded[:a].should == "1"
        decoded[:b].should == "2"
      end

      it "should decode using it's class methods", 'version number ist parsed' do
        DingDealer::Guid.decode_to_hash( "2-b-1-av1" ) == {'a' => '1', 'b' => '2'}
      end
    end
  end


  describe 'guid versioning' do
    describe "parsing" do
      context "with a valid value" do
        it "should return the version number at the end of the string" do
          DingDealer::Guid.prepare_decodable_for_decoding('some_stringv2').should == ['some_string', 2]
        end

        it "should return 4 providing v1v2v2v4" do
          DingDealer::Guid.prepare_decodable_for_decoding('v1v2v2v4').should == ['v1v2v2', 4]
        end

        it "should return 6666666 providing v1v2v2v6666666" do
          DingDealer::Guid.prepare_decodable_for_decoding('v1v2v2v6666666').should == ['v1v2v2', 6666666]
        end
      end

      context "with an invalid version", ' it should raise InvalidVersionFormat' do
        it "like an empty string" do
          lambda { DingDealer::Guid.prepare_decodable_for_decoding('') }.should raise_error(DingDealer::Guid::InvalidVersionFormat)
        end

        it "like a longer string without version" do
          lambda do 
            DingDealer::Guid.prepare_decodable_for_decoding('longer')
          end.should raise_error(DingDealer::Guid::InvalidVersionFormat)
        end

        it "like a string with v identifier but without number" do
          lambda do 
            DingDealer::Guid.prepare_decodable_for_decoding('stringv') 
          end.should raise_error(DingDealer::Guid::InvalidVersionFormat)
        end

        it "like only the version number" do
          lambda do 
            DingDealer::Guid.prepare_decodable_for_decoding('v33')
          end.should raise_error(DingDealer::Guid::InvalidVersionFormat)
        end

        it "like only the version number" do
          lambda do 
            DingDealer::Guid.prepare_decodable_for_decoding('33')
          end.should raise_error(DingDealer::Guid::InvalidVersionFormat)
        end

        it "like other crap" do
          lambda do 
            DingDealer::Guid.prepare_decodable_for_decoding('333333333333')
          end.should raise_error(DingDealer::Guid::InvalidVersionFormat)
        end
      end
    end


    context "with a non existing coder version" do
      it "should raise an InvalidCoderVersion" do
        lambda { DingDealer::Guid.new(0) }.should raise_error(DingDealer::Guid::InvalidCoderVersion)
      end
    end

    context "with an existing coder version" do
      it "should not raise an InvalidCoderVersion" do
        lambda { DingDealer::Guid.new(1) }.should_not raise_error
      end

      it "should set the version" do
        DingDealer::Guid.new(1).version.should be 1
      end

      it "should use the default given no version attribute" do
        DingDealer::Guid.new.version.should be DingDealer::Guid.version

        DingDealer::Guid.version = 1
        DingDealer::Guid.new.version.should be 1
      end
    end

  end
end


describe "version 2 coder" do


  before(:all) do
    DingDealer::Guid.version = 2
  end


  describe "encoding" do
    context "a string" do
      it "should return a encoded string" do
        DingDealer::Guid.encode('harras fass harras').should == "686172726173206661737320686172726173v2"
      end

      it "a decoded and encoded string should be the same " do
        DingDealer::Guid.decode( DingDealer::Guid.encode('harras fass harras') ).should == 'harras fass harras'
      end
    end

    context "a hash" do
      before(:each) do
        @hash = {:u => 'harras@example.com', :t => "20080823121212", :i => "6987", :c => 'Ziege'}
        @encoded = "752d686172726173406578616d706c652e636f6d2d742d32303038303832333132313231322d692d363938372d632d5a69656765v2"
      end

      it "a decoded and encoded hash should be the same " do
        DingDealer::Guid.encode(@hash).should == @encoded
      end

      it "a decoded and encoded string should be the same " do
        decoded = DingDealer::Guid.decode_to_hash( DingDealer::Guid.encode(@hash) ).symbolize_keys
        decoded.should == @hash
        decoded[:u].should == 'harras@example.com'
        decoded[:t].should == "20080823121212"
        decoded[:i].should == "6987"
        decoded[:c].should == 'Ziege'
      end

    end
  end

end


describe "version 3 coder" do

  before(:all) do
    DingDealer::Guid.version = 3
  end


  describe "encoding" do
    context "a string" do
      it "should return a encoded string" do
        DingDealer::Guid.encode('harras fass harras').should == "aGFycmFzIGZhc3MgaGFycmFzzv3"
      end

      it "a decoded and encoded string should be the same " do
        DingDealer::Guid.decode( DingDealer::Guid.encode('harras fass harras') ).should == 'harras fass harras'
      end
    end

    context "a hash" do
      before(:all) do
        @hash = {:u => 'harras@example.com', :t => "20080823121212", :i => "6987", :c => 'Ziege'}
        @encoded = "dS1oYXJyYXNAZXhhbXBsZS5jb20tdC0yMDA4MDgyMzEyMTIxMi1pLTY5ODctYy1aaWVnZQxv3"
      end

      it "a decoded and encoded hash should be the same " do
        DingDealer::Guid.encode(@hash).should == @encoded
      end

      it "a decoded and encoded string should be the same " do
        decoded = DingDealer::Guid.decode_to_hash( DingDealer::Guid.encode(@hash) ).symbolize_keys
        decoded.should == @hash
        decoded[:u].should == 'harras@example.com'
        decoded[:t].should == "20080823121212"
        decoded[:i].should == "6987"
        decoded[:c].should == 'Ziege'
      end
    end


    context "given some asci stuff" do
      def random_letter(length)
        (1...length).map{ (rand(26) + 97).chr }.to_s
      end

      def random_ascii_char(length)
        (1...length).map{ (rand(26) + 97).chr }.to_s
        # (1...length).map{ rand(256).chr }.to_s.gsub(':', '')
      end

      it "should also handle this" do
        300.times do
          hash = {}
          (rand(30) + 1).times do
            hash[random_letter(4)] = random_ascii_char(20)
          end

          DingDealer::Guid.decode_to_hash( DingDealer::Guid.encode(hash) ).should == hash

          # puts "=========="
          # puts hash.inspect
          # puts enc = DingDealer::Guid.encode(hash)
          # # DingDealer::Guid.decode_to_hash(enc)
          # puts "----------"
          # puts DingDealer::Guid.decode_to_hash( DingDealer::Guid.encode(hash) ).diff(hash)
          # DingDealer::Guid.decode_to_hash( DingDealer::Guid.encode(hash) ).should == hash
        end
      end
    end

  end
end