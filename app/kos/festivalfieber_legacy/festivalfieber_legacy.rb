module Kos::FestivalfieberLegacy
  ImportSetIdent  = 'festivalfieber_legacy'
  StoreIdent      = 'festivalfieber'

  def self.import_set
    @import_set ||= Kos::PocketStore.init_import_set(ImportSetIdent)
  end

  def self.store
    @store ||= Kos::PocketStore.init_store_with_import_set(StoreIdent, import_set)
  end

  def self.add_to_import_set_as_item(item)
    import_set.items << item
  end

  def self.add_to_import_set_as_group(group)
    import_set.groups << group
  end

end