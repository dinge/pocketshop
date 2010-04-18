class Kos::PocketStore::Group
  include Neo4j::NodeMixin

  has_n(:items).from(parent::Item, :groups)
  has_one(:store).from(parent::Store, :groups)
  has_one(:import_source)

  property :title
  property :description
  property :image_path

  index :title

  has_n(:children).from(self, :parent)
  has_one(:parent).to(self)


  def public_items
    items do 
      image_path.present?
    end
  end



  # def self.pub
  #   all.nodes.select do |group|
  #     group.image_path.present? &&
  #     group.items.any?
  #   end
  # end

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



  def self.create_from_import_set(store, import_set)
    Neo4j::Transaction.run do
      import_set.groups.each do |import_group|
        group = new(
          :title        =>  import_group.title,
          :description  =>  import_group.description,
          :image_path   =>  import_group.image_path
        )
        group.import_source = import_group
        group.store         = store
      end
    end
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