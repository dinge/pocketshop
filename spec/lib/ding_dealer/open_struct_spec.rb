require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DingDealer::OpenStruct do

  describe "the dynamic behaviour" do

    before(:each) do
      @open_struct = DingDealer::OpenStruct.new
    end

    it "should accept all attribute names as reader" do
      @open_struct.suppe?.should be_false
      @open_struct.suppe.should == nil
      @open_struct.suppe = "lecka"
      @open_struct.suppe.should == 'lecka'
      @open_struct.suppe?.should be_true
    end

  end



  describe "instance initalization", ' the differences to DingDealer::Struct' do

    context "without any arguments" do
      before do
        @open_struct = DingDealer::OpenStruct.new
      end

      it "should have attributes" do
        lambda { @open_struct.unexisting_attribute }.should_not raise_error(NoMethodError)
        lambda { @open_struct.unexisting_attribute = 'gang green' }.should_not raise_error(NoMethodError)
        @open_struct.unexisting_attribute.should == 'gang green'
      end
    end



    context "with an array of symbols as argument" do
      before do
        @open_struct = DingDealer::OpenStruct.new(:first_attribute, :second_attribute)
      end

      describe "unititalized attributes" do
        it "should not throw an exception", 'calling the reader' do
          lambda { @open_struct.unexisting_attribute }.should_not raise_error(NoMethodError)
          lambda { @open_struct.unexisting_attribute = 'kino' }.should_not raise_error(NoMethodError)
          @open_struct.unexisting_attribute.should == 'kino'
        end
      end
    end



    context "with an hash as argument" do
      before do
        @open_struct = DingDealer::OpenStruct.new(:first_attribute => 'dududu', :second_attribute => 'dadada', :a_nil_one => nil)
      end

      describe "unititalized attributes" do
        it "should not throw an exception", 'calling the reader' do
          lambda { @open_struct.unexisting_attribute }.should_not raise_error(NoMethodError)
          lambda { @open_struct.unexisting_attribute = 'tiger' }.should_not raise_error(NoMethodError)
          @open_struct.unexisting_attribute.should == 'tiger'
        end
      end
    end



    context "with a block" do
      before do
        @open_struct = DingDealer::OpenStruct.new do |s|
          s.first_attribute = 'dududu'
          s.second_attribute = 'dadada'
          third_attribute 'lalala'
          s.a_nil_one
        end
      end


      describe "unitialized attributes" do
        it "should not throw an exception", 'calling the reader' do
          lambda { @open_struct.unexisting_attribute }.should_not raise_error(NoMethodError)
          lambda { @open_struct.unexisting_attribute = 'tiger' }.should_not raise_error(NoMethodError)
          @open_struct.unexisting_attribute.should == 'tiger'
        end

      end
    end

  end
end