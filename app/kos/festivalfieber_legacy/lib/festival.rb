class Kos::FestivalfieberLegacy::Festival
  include Neo4j::NodeMixin

  has_one(:store_destination).from(Kos::PocketStore::Item, :import_source)
  has_one(:import_set).from(Kos::PocketStore::ImportSet, :items)

  def self.to_store
    parent::store.create_items_from_import_set(parent::import_set)
  end

  def title
    self[:meta_name]
  end

  def description
    self[:meta_name]
  end

  def identifier
    self[:id]
  end

  def image_path
    if image_path = (self[:logo_image_path] || self[:flyer_image_path])
      'http://www.festivalfieber.de/assets/show/%s' % image_path
    end
  end

  def large_image_path
    image_path
  end

  def price
  end

end