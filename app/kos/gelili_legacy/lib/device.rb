class Kos::GeliliLegacy::Device
  include Neo4j::NodeMixin

  has_one(:store_destination).from(Kos::PocketStore::Item, :import_source)

  def self.to_store
    Neo4j::Transaction.run do
      # Kos::PocketStore::Item.all.nodes.each(&:del)
      all.nodes.each { |node| node.to_store }
    end
  end

  def to_store
    self.store_destination = Kos::PocketStore::Item.new(
      :title           =>  self[:name_with_manufacturer_name],
      :desciption      =>  self[:description],
      :identifier      =>  self[:id],
      :image_path      =>  image_path,
      :large_image_path =>  large_image_path,
      :price           =>  nil
    )
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

end