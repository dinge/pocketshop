class Kos::GeliliLegacy::Importer

  def self.run
    import_devices_from_remote
    import_device_groups_from_remote
    delete_devices_without_image

    parent::Device.to_store
    parent::DeviceGroup.to_store
  end

  def self.import_devices_from_remote
    Neo4j::Transaction.run do
      Kos::GeliliLegacyRemote::Device.all.each do |remote_device|
        device = parent::Device.new
        remote_device.attributes.each do |key, value|
          device[key] = typecast_value(value)
        end
        device[:raw_import_external_source_id] = remote_device.id
      end
    end
  end

  def self.import_device_groups_from_remote
    Neo4j::Transaction.run do
      Kos::GeliliLegacyRemote::DeviceGroup.all.each do |remote_device_group|
        device_group = parent::DeviceGroup.new
        remote_device_group.attributes.each do |key, value|
          device_group[key] = value.to_s
        end
        device_group[:raw_import_external_source_id] = remote_device_group.id
      end
    end
  end
  
  def self.delete_devices_without_image
    Neo4j::Transaction.run do
      parent::Device.all.nodes.each do |device|
        device.del unless device[:path_of_attached_teaser_image]
      end
    end
  end

  def self.typecast_value(value)
    case value
    when Date, Time, DateTime
      value.to_s
#    when String
#      @use_iconv ? iconv_instance.iconv(value) : value
    else
      value
    end
  end
end
