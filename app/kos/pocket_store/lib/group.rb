class Kos::PocketStore::Group
  include Neo4j::NodeMixin

  has_n(:items).from(parent::Item, :groups)
  has_one :store

  has_one :import_source

  property :title
  property :description
  property :image_path

  index :title

  has_n(:children).from(self, :parent)
  has_one(:parent).to(self)


  def self.root_categories
    all.nodes.select { |c| c.parent.blank? }
  end

  def self_and_all_children
    all_children = children.to_a.inject([self] + children.to_a) do |memo, child|
      child.children.each { memo << c }
      memo
    end

    def all_children.items
      self.map { |c| c.items.to_a }.flatten.uniq
    end

    all_children
  end

end