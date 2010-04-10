class Kos::BattlemerchantCao::Category
  # is_a_neo_node do
  #   db.meta_info true
  # end

  include Neo4j::NodeMixin

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

  def image_file_name
    '%s.jpg' % Kos::BattlemerchantCao::Product.all.nodes.to_a.rand.article_number
  end

end
