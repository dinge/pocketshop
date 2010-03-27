class Kos::BattlemerchantCao::Importer

  ImportRootPath = Pathname.new('/var/folders/9Z/9ZywZ9boF7SRFVjh1FKXgU+++TM/-Tmp-/cao/product_exporter')
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
      importer.delete_all_before.run
    end

    # Neo4j::Transaction.run { parent::Product.all.nodes.each(&:del) }
    # Neo4j::Transaction.run { parent::Category.all.nodes.each(&:del) }
    # Neo4j::Transaction.run { parent::ProductCategory.all.nodes.each(&:del) }



    # import_products
    # import_product_categories
    # import_product_category_relationships
    # import_product_images
    # delete_products_without_image
    # build_product_category_taxonomie
    ""
  end

  # graph.run do
  #
  # end


  # def self.import_products
  #   read_yaml_file( ImportRootPath.join('cao_product.yaml').to_s ).each do |record|
  #     Neo4j::Transaction.run do
  #       puts iconv_instance.iconv(record['kurzname'])
  #       parent::Product.new(
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
  #   read_yaml_file( ImportRootPath.join('cao_category.yaml').to_s ).each do |record|
  #     Neo4j::Transaction.run do
  #       puts iconv_instance.iconv(record['name'])
  #       parent::ProductCategory.new(
  #         :name             => iconv_instance.iconv(record['name']),
  #         :source_id        => record['id'],
  #         :source_parent_id => record['top_id']
  #       )
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

  def self.import_product_images
    require "rio"
    Neo4j::Transaction.run do
      parent::Product.to_a.each do |product|
        putc "."
        next if product.article_number.blank?
        img = ProductImagePathTemplate % product.article_number
        ['', 'b', 'c'].each do |image_suffix|
          destination_file = ImportRootPath.join('images', '%s%s.jpg' % [product.article_number, image_suffix])
          next if File.exists?(destination_file)
          puts destination_file
          rio(img) > rio(destination_file) rescue OpenURI::HTTPError
        end
      end
    end
  end

  def self.delete_products_without_image
    Neo4j::Transaction.run do
      parent::Product.to_a.each do |product|
        unless File.exists?(ImportRootPath.join('images', '%s.jpg' % product.article_number))
          product.del
        end
      end
    end
  end

  def self.build_product_category_taxonomie
    Neo4j::Transaction.run do
      parent::ProductCategory.to_a.each do |category|
        putc "."
        if parent_category = parent::ProductCategory.find_first(:source_id => category.source_parent_id)
          parent_category.children << category
        end
      end
    end
  end



end
