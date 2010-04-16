class Kos::GeliliLegacy::DeviceGroup
  include Neo4j::NodeMixin

  has_one(:store_destination).from(Kos::PocketStore::Group, :import_source)
  has_one(:import_set).from(Kos::PocketStore::ImportSet, :groups)

  def self.to_store
    parent::store.create_groups_from_import_set(parent::import_set)
    self.build_taxonomy
    self.connect_items_to_groups
    self.add_image_paths
  end


  def title
    self[:name]
  end

  def description
    self[:name]
  end

  def image_path
  end


  def self.build_taxonomy
    Neo4j::Transaction.run do
      (device_groups = all.nodes.to_a).each do |device_group|
        if parent_group = device_groups.find { |dg| device_group[:parent_id] == dg[:raw_import_external_source_id] }
          parent_group.store_destination.children << device_group.store_destination
        end
      end
    end
  end

  def self.connect_items_to_groups
    Neo4j::Transaction.run do
      devices = parent::Device.all.nodes.to_a
      device_groups = all.nodes.to_a
      devices.each do |device|
        if (device_group = device_groups.find { |dg| dg[:raw_import_external_source_id] == device[:device_group_id] })
          device_group.store_destination.items << device.store_destination
        end
      end
    end
  end

  def self.add_image_paths
    Neo4j::Transaction.run do
      (device_groups = all.nodes.to_a).each do |device_group|
        if store_destination = device_group.store_destination
          if item = store_destination.items.to_a.select{ |item| item.image_path.present? }.rand
            store_destination.image_path = item.image_path
          end
        end
      end
    end
  end



end