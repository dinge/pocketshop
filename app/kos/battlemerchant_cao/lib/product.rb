require 'neo4j/extensions/reindexer'

class Kos::BattlemerchantCao::Product
  # is_a_neo_node do
  #   db.meta_info true
  # end
  include Neo4j::NodeMixin
  include ActiveModel::Conversion
  include ActiveModel::Serializers
  include ActiveModel::Serializers
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml

  # include ActiveModel::Validations

  def persisted?
    true
  end

  def attributes
    attr = props
    attr.keys.each {|k| attr.delete k if k[0] == ?_}
    attr
  end


  def serializable_hash(options = nil)
    options ||= {}

    options[:only]   = Array.wrap(options[:only]).map { |n| n.to_s }
    options[:except] = Array.wrap(options[:except]).map { |n| n.to_s }

    attribute_names = attributes.keys.sort
    if options[:only].any?
      attribute_names &= options[:only]
    elsif options[:except].any?
      attribute_names -= options[:except]
    end

    method_names = Array.wrap(options[:methods]).inject([]) do |methods, name|
      methods << name if respond_to?(name.to_s)
      methods
    end

    (attribute_names + method_names).inject({}) { |hash, name|
      hash[name] = respond_to?(name.to_s) ? send(name) : self[name]
      hash
    }
  end


  def to_json(options = {})
    super(options.reverse_merge(:only => [:kurzname, :artnum, :vk5b, :rec_id]))
  end



  # offers :product do
  #   mapping do
  #     name            :kurzname
  #     article_number  :artnum
  #     price           :vkfb
  #     text            :rec_id
  #   end
  # end
  # 
  # 
  # 
  # 
  # class Gizmo
  # 
  #   def initialize(wrapped)
  #     @wrapped = wrapped
  #   end
  # 
  #   def mapping(&block)
  #     instance_eval(&block)
  #   end
  # 
  # end
  # 
  # 
  # def mapping(wrapped)
  #   Gizmo.new(wrapped)
  # end


  # kox.io do
  #
  # end
  #
  # kos.import do
  #
  # end

  # property :name
  # property :article_number
  # property :price
  # property :source_id
  #
  # index :name
  # index :article_number
  # index :price
  # index :source_id
  #
  # has_n(:categories).to(parent::ProductCategory)
  #
  # ImageRoot = Rails.root.join('public', 'images', 'product_images')
  #
  # def image_file_name(name_suffix = nil)
  #   '%s%s.jpg' % [article_number, name_suffix]
  # end
  #
  # def image_file_names
  #   ['', 'b', 'c'].map do |name_suffix|
  #     image_file_name(name_suffix)
  #   end.select do |image|
  #     File.exists?( ImageRoot.join(image) )
  #   end
  # end
  #
  # def products_of_same_categories
  #   categories.map { |c| c.products.map }.to_a.flatten.uniq
  # end
  #
  # def products_of_same_categories_and_their_children
  #   categories.map { |category| category.self_and_all_children.products }.flatten.uniq
  # end
  #
  #
  #
  # class Importer
  # end

end