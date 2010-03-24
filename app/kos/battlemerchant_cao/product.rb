class Kos::BattlemerchantCao::Product
  is_a_neo_node do
    db.meta_info true
  end

  property :name
  property :article_number
  property :price
  property :source_id

  index :name
  index :article_number
  index :price
  index :source_id

  has_n(:categories).to(Tools::MiniShop::ProductCategory)

  ImageRoot = Rails.root.join('public', 'images', 'product_images')

  def image_file_name(name_suffix = nil)
    '%s%s.jpg' % [article_number, name_suffix]
  end

  def image_file_names
    ['', 'b', 'c'].map do |name_suffix|
      image_file_name(name_suffix)
    end.select do |image|
      File.exists?( ImageRoot.join(image) )
    end
  end

  def products_of_same_categories
    categories.map { |c| c.products.map }.to_a.flatten.uniq
  end

  def products_of_same_categories_and_their_children
    categories.map { |category| category.self_and_all_children.products }.flatten.uniq
  end

end
