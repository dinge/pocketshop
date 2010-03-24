class Kos::BattlemerchantCao::YamlImporter
  # 
  # ImportRootPath = Rails.root.join('tmp', 'products')
  # ProductImagePathTemplate = 'http://www.battlemerchant.com/images/product_images/popup_images/%s.jpg'
  # 
  # def self.run
  #   # Neo4j::Transaction.run { Tools::MiniShop::Product.to_a.each(&:del) }
  #   # Neo4j::Transaction.run { Tools::MiniShop::ProductCategory.to_a.each(&:del) }
  # 
  #   # import_products
  #   # import_product_categories
  #   # import_product_category_relationships
  #   import_product_images
  #   # delete_products_without_image
  #   # build_product_category_taxonomie
  #   ""
  # end
  # 
  # def self.iconv_instance
  #   @_iconv_instance ||= Iconv.new('utf-8', 'latin1')
  # end
  # 
  # 
  # def self.import_products
  #   read_yaml_file( ImportRootPath.join('yamls', 'cao_product.yaml').to_s ).each do |record|
  #     Neo4j::Transaction.run do
  #       puts iconv_instance.iconv(record['kurzname'])
  #       Tools::MiniShop::Product.new(
  #         :name           => iconv_instance.iconv(record['kurzname']),
  #         :article_number => record['artnum'],
  #         :price          => record['vk5b'],
  #         :source_id      => record['rec_id']
  #       )
  #     end
  #   end
  # end
  # 
  # def self.import_product_categories
  #   read_yaml_file( ImportRootPath.join('yamls', 'cao_category.yaml').to_s ).each do |record|
  #     Neo4j::Transaction.run do
  #       puts iconv_instance.iconv(record['name'])
  #       Tools::MiniShop::ProductCategory.new(
  #         :name             => iconv_instance.iconv(record['name']),
  #         :source_id        => record['id'],
  #         :source_parent_id => record['top_id']
  #       )
  #     end
  #   end
  # end
  # 
  # def self.import_product_category_relationships
  #   read_yaml_file( ImportRootPath.join('yamls', 'cao_product_category.yaml').to_s ).each do |record|
  #     Neo4j::Transaction.run do
  #       putc "."
  #       product = Tools::MiniShop::Product.find_first(:source_id => record['artikel_id'])
  #       product_category = Tools::MiniShop::ProductCategory.find_first(:source_id => record['kat_id'])
  #       if product && product_category
  #         product.categories << product_category
  #       end
  #     end
  #   end
  # end
  # 
  # def self.import_product_images
  #   require "rio"
  #   Neo4j::Transaction.run do
  #     Tools::MiniShop::Product.to_a.each do |product|
  #       putc "."
  #       next if product.article_number.blank?
  #       img = Tools::MiniShop::YamlImporter::ProductImagePathTemplate % product.article_number
  #       ['', 'b', 'c'].each do |image_suffix|
  #         destination_file = ImportRootPath.join('images', '%s%s.jpg' % [product.article_number, image_suffix])
  #         next if File.exists?(destination_file)
  #         puts destination_file
  #         rio(img) > rio(destination_file) rescue OpenURI::HTTPError
  #       end
  #     end
  #   end
  # end
  # 
  # def self.delete_products_without_image
  #   Neo4j::Transaction.run do
  #     Tools::MiniShop::Product.to_a.each do |product|
  #       unless File.exists?(ImportRootPath.join('images', '%s.jpg' % product.article_number))
  #         product.del
  #       end
  #     end
  #   end
  # end
  # 
  # def self.build_product_category_taxonomie
  #   Neo4j::Transaction.run do
  #     Tools::MiniShop::ProductCategory.to_a.each do |category|
  #       putc "."
  #       if parent_category = Tools::MiniShop::ProductCategory.find_first(:source_id => category.source_parent_id)
  #         parent_category.children << category
  #       end
  #     end
  #   end
  # end
  # 
  # def self.read_yaml_file(import_file)
  #   returning(records = []) do
  #     YAML.load_file(import_file).each do |ident, attributes|
  #       records << attributes
  #     end
  #   end
  # end
  # 
  # 
end
