require "rio"
class Kos::BattlemerchantCao::Importer

  ImportRootPath = Rails.root.join('tmp/import/battlemerchant_cao')
  ProductImagePathTemplate = 'http://www.battlemerchant.com/images/product_images/popup_images/%s.jpg'

  def self.run
    import_sets = [
      { :klass => parent::Product,
        :yaml_file => ImportRootPath.join('cao_product.yaml'),
        :external_source_id_field => :rec_id },
      { :klass => parent::Category,
        :yaml_file => ImportRootPath.join('cao_category.yaml'),
        :external_source_id_field => :id },
      { :klass => parent::ProductCategory,
        :yaml_file => ImportRootPath.join('cao_product_category.yaml') }
    ]

    import_sets.each do |import_set|
      importer = Kos::YamlImporter::RawImport.new(import_set[:klass], import_set[:yaml_file])
      importer.external_source_id_field = import_set[:external_source_id_field]
      # importer.delete_all_before.delete_unexising.update_existing.run
      importer.use_iconv.delete_all_before.run
    end

    import_product_images
    delete_products_without_image

    parent::Product.to_store
    parent::Category.to_store

    # build_product_category_taxonomie
    ""
  end

  def self.import_product_images
    Neo4j::Transaction.run do
      parent::Product.all.nodes.each do |product|
        putc "."
        next if product[:artnum].blank?
        img = ProductImagePathTemplate % product[:artnum]
        ['', 'b', 'c'].each do |image_suffix|
          destination_file = ImportRootPath.join('images', '%s%s.jpg' % [product[:artnum], image_suffix])
          unless File.exists?(destination_file)
            puts destination_file
            rio(img) > rio(destination_file) rescue OpenURI::HTTPError
          end
        end
      end
    end
  end

  def self.delete_products_without_image
    Neo4j::Transaction.run do
      parent::Product.all.nodes.each do |product|
        unless File.exists?(ImportRootPath.join('images', '%s.jpg' % product[:artnum]))
          product.del
        end
      end
    end
  end



  # graph.run do
  #
  # end

  # def self.build_product_category_taxonomie
  #   Neo4j::Transaction.run do
  #     parent::ProductCategory.all.nodes.each do |category|
  #       putc "."
  #       if parent_category = parent::ProductCategory.find_first(:source_id => category.source_parent_id)
  #         parent_category.children << category
  #       end
  #     end
  #   end
  # end


  # def self.import_product_category_relationships
  #   read_yaml_file( ImportRootPath.join('cao_product_category.yaml').to_s ).each do |record|
  #     Neo4j::Transaction.run do
  #       putc "."
  #       product = parent::Product.find_first(:source_id => record['artikel_id'])
  #       product_category = parent::ProductCategory.find_first(:source_id => record['kat_id'])
  #       if product && product_category
  #         product.categories << product_category
  #       end
  #     end
  #   end
  # end


end
