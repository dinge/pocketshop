class Kos::FestivalfieberLegacy::Tag
  include Neo4j::NodeMixin

  has_one(:store_destination).from(Kos::PocketStore::Group, :import_source)
  has_one(:import_set).from(Kos::PocketStore::ImportSet, :items)

  def title
    self[:title]
  end

  def description
    self[:title]
  end

  def image_path
  end



  def self.to_store
    parent::store.create_groups_from_import_set(parent::import_set)
    self.connect_items_to_groups
    self.add_image_paths
  end

  def self.connect_items_to_groups
    Neo4j::Transaction.run do
      items = parent.store.items.to_a
      parent.store.groups.each do |group|
        items.select do |item|
          item.import_source[:tag_names].split('|').include?(group.title)
        end.each do |item|
          group.items << item
        end
      end
    end
  end

  def self.add_image_paths
    Neo4j::Transaction.run do
      parent.store.groups.each do |group|
        if (images = group.public_items).any?
          group.image_path = images.to_a.rand.image_path
        end
      end
    end
  end

end