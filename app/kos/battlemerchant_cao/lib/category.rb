class Kos::BattlemerchantCao::Category
  include Neo4j::NodeMixin

  has_one(:store_destination).from(Kos::PocketStore::Group, :import_source)

  def self.to_store
    Neo4j::Transaction.run do
      # Kos::PocketStore::Group.all.nodes.each(&:del)
      all.nodes.each { |node| node.to_store }
    end
    self.build_taxonomie
    self.connect_items_to_groups
    self.add_image_paths
  end

  def to_store
    self.store_destination = Kos::PocketStore::Group.new(
      :title        =>  self[:name],
      :description  =>  self[:name]
    )
  end

  def self.build_taxonomie
    Neo4j::Transaction.run do
      (categories = all.nodes.to_a).each do |category|
        if parent_category = categories.find { |c| category[:top_id] == c[:raw_import_external_source_id] }
          parent_category.store_destination.children << category.store_destination
        end
      end
    end
  end

  def self.connect_items_to_groups
    Neo4j::Transaction.run do
      products = parent::Product.all.nodes.to_a
      categories = all.nodes.to_a
      product_categories = parent::ProductCategory.all.nodes.to_a

      product_categories.each do |product_category|
        product   = products.find { |p| p[:rec_id] == product_category[:artikel_id] }
        category  = categories.find { |c| c[:id] == product_category[:kat_id] }
        if product && category
          category.store_destination.items << product.store_destination
        end
      end
    end
  end

  def self.add_image_paths
    Neo4j::Transaction.run do
      (categories = all.nodes.to_a).each do |category|
        if store_destination = category.store_destination
          if item = store_destination.items.to_a.rand
            store_destination.image_path = item.image_path
          end
        end
      end
    end
  end



  # itsa.giznode do
  #
  # end

  # property :name
  # property :source_id
  # property :source_parent_id
  #
  # index :name
  # index :source_id
  # index :source_parent_id
  #
  # has_n(:products).from(parent::Product, :categories)
  #
  # has_n(:children).from(self, :parent)
  # has_one(:parent).to(self)
  #
  #
  # def self.root_categories
  #   to_a.select { |c| c.parent.blank? }
  # end
  #
  # def self_and_all_children
  #   all_children = children.to_a.inject([self] + children.to_a) do |memo, child|
  #     child.children.each { memo << c }
  #     memo
  #   end
  #
  #   def all_children.products
  #     self.map { |c| c.products.to_a }.flatten.uniq
  #   end
  #
  #   all_children
  # end
  #
  # def image_file_name
  #   '%s.jpg' % self_and_all_children.products.rand.article_number
  # end


end
