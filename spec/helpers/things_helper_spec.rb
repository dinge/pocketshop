# require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# 
# describe ThingsHelper, :type => :helper do
#   before(:all) do
#     helper.extend NavigationHelper
#   end
# 
#   before do
#     @thing = mock(Thing, :updated_at => fixed_datetime, :created_at => fixed_datetime, :version => 10)
#   end
# 
# 
#   describe "display of nodes metainfo", " #node_meta_info(node)" do
# 
#     context "a value object (aka a new_record?)" do
#       before { @thing.stub!(:new_record?).and_return(true) }
# 
#       it "should be empty" do
#         helper.node_meta_info(@thing).should be_blank
#       end
#     end
# 
#     context "a neo node" do
#       before { @thing.stub!(:new_record?).and_return(false) }
# 
#       context "without a creator" do
#         it "should show some meta information without the creator's name" do
#           helper.node_meta_info(@thing).should have_tag('span')
#           helper.node_meta_info(@thing).should be_include(fixed_datetime.to_s(:db))
#           helper.node_meta_info(@thing).should be_include("10")
#         end
#       end
# 
#       context "with a creator" do
#         it "should show some meta information with the creator's name" do
#           @thing.stub!(:creator).and_return(mock_model(Thing, :name => 'Dieter'))
#           helper.node_meta_info(@thing).should be_include('Dieter')
#           helper.node_meta_info(@thing).should be_include(fixed_datetime.to_s(:db))
#           helper.node_meta_info(@thing).should be_include("10")
#         end
#       end
#     end
# 
#   end
# end
