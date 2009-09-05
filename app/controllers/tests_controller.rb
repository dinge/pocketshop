class TestsController < ApplicationController
  use_neo4j_transaction
  before_filter :init_items

  def with
  end
  
  def with_xml
    respond_to do |wants|
      wants.xml
    end
  end

  def without
    
  end

protected

  def init_items
    item = Struct.new(:name, :age)
    # @items = (0..1000).map{ |i| item.new("name_#{i}", i) }
    @items = (0..10).map{ |i| item.new("name_#{i}", i) }
  end

end
