module Kos::PocketStore

  class << self

    def store_by_ident(ident)
      Store.by_ident(ident)
    end

    def public_groups_by_store(store)
      groups = store.groups do
        image_path.present? && items.any?
      end
      groups.extend GroupPresenter
      groups
    end

    def public_items_by_store(store)
      returning(items = store.items) do
        items.extend ItemPresenter
      end
    end

  end


end