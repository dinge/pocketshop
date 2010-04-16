class Kos::PocketStore::Item
  include Neo4j::NodeMixin

  has_n(:groups).to(parent::Group)
  has_one(:store).from(parent::Store, :items)
  has_one(:import_source)

  property :title
  property :identifier
  property :description
  property :image_path
  property :large_image_path

  property :price

  index :title


  def self.create_from_import_set(store, import_set)
    Neo4j::Transaction.run do
      import_set.items.each do |import_item|
        item = new(
          :title              =>  import_item.title,
          :description        =>  import_item.description,
          :identifier         =>  import_item.identifier,
          :image_path         =>  import_item.image_path,
          :large_image_path   =>  import_item.large_image_path,
          :price              =>  import_item.price
        )
        item.import_source  = import_item
        item.store          = store
      end
    end
  end

end