require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DingDealer::Struct do

  describe "instance initalization" do

    context "without any arguments" do
      before do
        @struct = DingDealer::Struct.new
      end

      it "should have no attributes" do
        lambda { @struct.unexisting_attribute }.should raise_error(NoMethodError)
        lambda { @struct.unexisting_attribute = 'gang green' }.should raise_error(NoMethodError)
      end

      it "should return false", 'calling the predicate method' do
        @struct.unexisting_attribute?.should be_false
      end
    end



    context "with an array of symbols as argument" do
      before do
        @struct = DingDealer::Struct.new(:first_attribute, :second_attribute)
      end

      it "should have those as attributes", 'without any default values' do
        @struct.first_attribute.should be_nil
        @struct.second_attribute.should be_nil
      end

      it "should return true", 'calling their specific predicate methods' do
        @struct.first_attribute?.should be_true
        @struct.second_attribute?.should be_true
      end


      it "should be possible to change the attribute values", 'using standard writers' do
        @struct.first_attribute = 'suppe'
        @struct.first_attribute.should == 'suppe'

        @struct.first_attribute = 'käse'
        @struct.first_attribute.should == 'käse'
      end


      it "should be possible to change the attribute values", 'using writers without "="' do
        @struct.first_attribute('suppe')
        @struct.first_attribute.should == 'suppe'

        @struct.first_attribute('käse')
        @struct.first_attribute.should == 'käse'
      end

      it "should be possible to change the attribute values", 'using a block' do
        @struct.set do
          first_attribute 'suppe'
        end
        @struct.first_attribute.should == 'suppe'

        @struct.set do
          first_attribute 'ziege'
        end.set do |s|
          s.second_attribute = 'schoko'
        end

        @struct.first_attribute.should == 'ziege'
        @struct.second_attribute.should == 'schoko'
      end

      describe "unititalized attributes" do
        it "should throw an exception", 'calling the reader' do
          lambda { @struct.unexisting_attribute }.should raise_error(NoMethodError)
          lambda { @struct.unexisting_attribute == 'kino' }.should raise_error(NoMethodError)
        end

        it "should return false", 'calling the predicate method' do
          @struct.unexisting_attribute?.should be_false
        end
      end
    end



    context "with an hash as argument" do
      before do
        @struct = DingDealer::Struct.new(:first_attribute => 'dududu', :second_attribute => 'dadada', :a_nil_one => nil)
      end

      it "should have those as attributes", 'with hash values as default values' do
        @struct.first_attribute.should == 'dududu'
        @struct.second_attribute.should == 'dadada'
        @struct.a_nil_one.should be_nil
      end

      it "should return true", 'calling their specific predicate methods' do
        @struct.first_attribute?.should be_true
        @struct.second_attribute?.should be_true
      end

      it "should be possible to change the attribute values", 'using standard writers' do
        @struct.first_attribute.should == 'dududu'

        @struct.first_attribute = 'suppe'
        @struct.first_attribute.should == 'suppe'
      end

      it "should be possible to change the attribute values", 'using writers without "="' do
        @struct.first_attribute('suppe')
        @struct.first_attribute.should == 'suppe'

        @struct.first_attribute('käse')
        @struct.first_attribute.should == 'käse'
      end

      it "should be possible to change the attribute values", 'using writers without "="' do
        @struct.first_attribute('suppe')
        @struct.first_attribute.should == 'suppe'

        @struct.first_attribute('käse')
        @struct.first_attribute.should == 'käse'
      end

      describe "unititalized attributes" do
        it "should throw an exception", 'calling the reader' do
          lambda { @struct.unexisting_attribute }.should raise_error(NoMethodError)
          lambda { @struct.unexisting_attribute == 'tiger' }.should raise_error(NoMethodError)
        end

        it "should return false", 'calling the predicate method' do
          @struct.unexisting_attribute?.should be_false
        end
      end
    end



    context "with a block" do
      before do
        @struct = DingDealer::Struct.new do |s|
          s.first_attribute = 'dududu'
          s.second_attribute = 'dadada'
          third_attribute 'lalala'
          s.a_nil_one
        end
      end

      it "should have those as attributes", 'without values as default values' do
        @struct.first_attribute.should == 'dududu'
        @struct.second_attribute.should == 'dadada'
        @struct.third_attribute.should == 'lalala'
        @struct.a_nil_one.should be_nil
      end

      describe "unitialized attributes" do
        it "should throw an exception", 'calling the reader' do
          lambda { @struct.unexisting_attribute }.should raise_error(NoMethodError)
          lambda { @struct.unexisting_attribute == 'tiger' }.should raise_error(NoMethodError)
        end

        it "should return false", 'calling the predicate method' do
          @struct.unexisting_attribute?.should be_false
        end
      end
    end



    context "with a mix of them all" do
      context "like an array" do
        before do
          @struct = DingDealer::Struct.new(:first_attribute) do
            second_attribute 'lalala'
            a_nil_one
          end
        end

        it "should have those as attributes" do
          @struct.first_attribute.should be_nil
          @struct.second_attribute.should == 'lalala'
          @struct.a_nil_one.should be_nil
        end
      end

      context "like a hash" do
        before do
          @struct = DingDealer::Struct.new(:first_attribute => 'zuppe') do |s|
            s.second_attribute = 'lalala'
          end
        end

        it "should have those as attributes" do
          @struct.first_attribute.should == 'zuppe'
          @struct.second_attribute.should == 'lalala'
        end
      end
    end

  end



  describe "method chaining" do

    before do
      @struct = DingDealer::Struct.new(:name => 'heiner', :street => nil)
    end

    it "should allow method chaining" do
      @struct.name.should == 'heiner'
      @struct.street.should be_nil
      @struct.name('paul').should be @struct
      @struct.name.should == 'paul'
      @struct.name
      @struct.name.should == 'paul'
      @struct.name(nil).should be @struct
      @struct.name.should be_nil
      @struct.name('peter').name('rainer').street('achtern diek')
      @struct.name.should == 'rainer'
      @struct.street.should == 'achtern diek'
    end
  end



  describe "some methods" do

    before do
      @hash = {'name' => 'heiner', 'street' => 'pevee'}
      @struct = DingDealer::Struct.new(@hash)
    end

    describe "#to_hash" do
      it "should return its values as hash" do
        @struct.to_hash.should == @hash
      end
    end

    describe "#to_a" do
      it "should return its values as array" do
        @struct.to_a.should == @hash.to_a
      end
    end

    describe "#[]" do
      it "should return its values as array" do
        @struct[:name].should == @hash['name']
      end
    end
  end



  describe "#dingsl_accessor" do

    it "should by accessable in all objects" do
      Object.should respond_to(:dingsl_accessor)
    end

    context "complex structures" do
      before do
        @rezept = dingsl_accessor do |rezept|
          rezept.zutaten = dingsl_accessor(:aroma) do |zutat|
            zucker 10
            wasser 500
            zutat.mehl = 1000
          end
          rezept.zubereitung = dingsl_accessor(:backen => 300) do
            kneten 30
            wuerzen(99).trocknen(88)
          end
        end
      end

      it "should behave like the other stuff" do
        @rezept.zutaten.zucker.should == 10
        @rezept.zutaten.wasser.should == 500
        @rezept.zutaten.mehl.should == 1000
        @rezept.zutaten.aroma.should be_nil

        @rezept.zubereitung.kneten.should == 30
        @rezept.zubereitung.backen.should == 300
        @rezept.zubereitung.wuerzen.should == 99
        @rezept.zubereitung.trocknen.should == 88

        @rezept.zubereitung.kneten = 50
        @rezept.zubereitung.kneten.should == 50
        @rezept.zubereitung.kneten?.should be_true
        @rezept.zubereitung.stinkt?.should be_false
      end

      it "#to_hash should export a deep nestet structure" do
        @rezept.to_hash.should be_a_kind_of(HashWithIndifferentAccess)
        @rezept.to_hash.should ==
          { "zutaten" =>
            { "zucker" => 10, "wasser" => 500, "mehl" => 1000, 'aroma' => nil },
              "zubereitung" => { "kneten" => 30, "backen" => 300, 'wuerzen' => 99, 'trocknen' => 88 }
          }

        @rezept.to_hash[:zutaten][:zucker].should == 10
        @rezept.to_hash['zutaten']['zucker'].should == 10
        @rezept[:zutaten][:zucker].should == 10
        @rezept['zutaten']['zucker'].should == 10
      end

      it "should be changeable by block magic" do
        @rezept.zubereitung do
          kneten 666
        end
        @rezept.zubereitung.kneten.should == 666


        @rezept.set do
          zutaten.set do
            wasser 10
            aroma 57
          end
          zutaten.mehl = 55
          zubereitung.kneten 888
        end

        @rezept.zutaten.wasser.should == 10
        @rezept.zutaten.mehl.should == 55
        @rezept.zutaten.aroma.should == 57
        @rezept.zubereitung.kneten.should == 888
      end
    end

  end

end