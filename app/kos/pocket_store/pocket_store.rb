module Kos::PocketStore

  class << self

    def init_import_set(import_set_ident)
      ImportSet.init(import_set_ident)
    end

    def init_store_with_import_set(store_ident, import_set)
      Store.init_with_import_set(store_ident, import_set)
    end

    def store_by_ident(ident)
      Store.by_ident(ident)
    end

    def public_groups_by_store(store)
      store.public_groups.extend(GroupPresenter)
    end

    def public_items_by_store(store)
      store.public_items.extend(ItemPresenter)
    end

  end

end