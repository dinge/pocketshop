class Kos::GeliliLegacy::Device
  include Neo4j::NodeMixin

  has_one(:store_destination).from(Kos::PocketStore::Item, :import_source)
  has_one(:import_set).from(Kos::PocketStore::ImportSet, :items)

  def self.to_store
    parent::store.create_items_from_import_set(parent::import_set)
  end


  def title
    self[:name_with_manufacturer_name]
  end

  def description
    self[:description]
  end

  def identifier
    self[:id]
  end

  def image_path
    if image_path = self[:path_of_attached_teaser_image]
      'http://gelili.de/public_assets/%s' % image_path
    end
  end

  def large_image_path
    image_path
    # if image_path = self[:path_of_attached_main_image]
    #   'http://gelili.de/public_assets/%s' % image_path
    # end
  end

  def price
  end

end