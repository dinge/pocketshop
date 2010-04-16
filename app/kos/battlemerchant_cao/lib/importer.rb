require "rio"
class Kos::BattlemerchantCao::Importer

  ImportRootPath = Rails.root.join('tmp/import/battlemerchant_cao')
  ProductImagePathTemplate = 'http://www.battlemerchant.com/images/product_images/popup_images/%s.jpg'

  def self.run
    imports = [
      { :klass                        => parent::Product,
        :yaml_file                    => ImportRootPath.join('cao_product.yaml'),
        :external_source_id_field     => :rec_id,
        :connect_as                   => :item  },

      { :klass                        => parent::Category,
        :yaml_file                    => ImportRootPath.join('cao_category.yaml'),
        :external_source_id_field     => :id,
        :connect_as                   => :group },

      { :klass                        => parent::ProductCategory,
        :yaml_file                    => ImportRootPath.join('cao_product_category.yaml'),
        :connect_as                   => :thing  }
    ]

    imports.each do |import|
      Kos::YamlImporter::RawImport.new(import[:klass], import[:yaml_file]).
        external_source_id_field(import[:external_source_id_field]).
        connect_to_import_set(parent::import_set, import[:connect_as]).
        use_iconv.
        delete_all_before.
        run
    end

    import_product_images
    delete_products_without_image

    parent::Product.to_store
    parent::Category.to_store
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
            # rio(img) > rio(destination_file) rescue OpenURI::HTTPError
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


end
