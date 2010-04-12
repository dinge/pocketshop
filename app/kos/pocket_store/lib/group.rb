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

  def self.pub
    all.nodes.select do |group|
      group.image_path.present?
    end
  end

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


  include ActiveModel::Conversion
  include ActiveModel::Serializers
  include ActiveModel::Serializers
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml

  def attributes
    props.delete_if { |k,v| k[0] == ?_ }
  end

end