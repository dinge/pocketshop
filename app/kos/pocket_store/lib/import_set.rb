class Kos::PocketStore::ImportSet
  include Neo4j::NodeMixin

  has_one(:store).from(parent::Store, :import_sets)
  has_n(:groups)
  has_n(:items)
  has_n(:things)

  property  :title
  property  :ident

  index :title
  index :ident

  def self.init(ident)
    Neo4j::Transaction.run do
      all.nodes.find { |n| n.ident == ident } || new(:ident => ident)
    end
  end

end