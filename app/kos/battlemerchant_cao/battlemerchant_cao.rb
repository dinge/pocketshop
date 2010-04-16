module Kos::BattlemerchantCao
  ImportSetIdent  = 'battlemerchant_cao'
  StoreIdent      = 'battlemerchant'

  def self.import_set
    @import_set ||= Kos::PocketStore::ImportSet.init(ImportSetIdent)
  end

  def self.store
    @store ||= Kos::PocketStore::Store.init_with_import_set(StoreIdent, import_set)
  end

  def self.add_to_import_set_as_item(item)
    import_set.items << item
  end

  def self.add_to_import_set_as_group(group)
    import_set.groups << group
  end


  # itsa.giznode_hub do
  #
  # end

end