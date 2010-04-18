class Kos::PocketStore::Store
  include Neo4j::NodeMixin

  has_n(:import_sets)
  has_n(:items).to(parent::Item)
  # using store_groups as @to_type here to avoid naming clash with Item#groups aka. Store#Items
  has_n(:groups).to(parent::Group, :store_groups)
  property  :title
  property  :ident

  index :title
  index :ident

  # def self.filter_nodes
  #   Neo4j::IndexNode.instance.outgoing(self).filter { yield }
  # end

  def self.by_ident(store_ident)
    Neo4j::IndexNode.instance.outgoing(self).filter{ ident == store_ident  }.first
    # filter_nodes { ident == store_ident }.first
  end

  def public_groups
    groups do
      image_path.present? && items.any?
    end
  end

  def public_items
    items do
      image_path.present?
    end
  end



  def self.init_with_import_set(ident, import_set)
    Neo4j::Transaction.run do
      store = by_ident(ident) || new(:ident => ident)
      store.import_sets << import_set unless store.import_sets.include?(import_set)
      store
    end
  end

  def create_groups_from_import_set(import_set)
    Kos::PocketStore::Group.create_from_import_set(self, import_set)
  end

  def create_items_from_import_set(import_set)
    Kos::PocketStore::Item.create_from_import_set(self, import_set)
  end

  def self.dump
    all.nodes.map do |store|
      { :title  => store.title,
        :ident  => store.ident,
        :groups => store.dump }
    end
  end

  def dump
    groups.map do |group|
      { :title    => group.title,
        :items    => group.items.map(&:title),
        :children => group.children.map(&:title) }
    end
  end

end