class Kos::YamlImporter::RawImport

  attr_accessor :counter_hops, :external_source_id_field

  def initialize(klass, yaml_file)
    @klass, @yaml_file = klass, yaml_file
    # klass = ('%s::%s' % [parent, klass_sym.to_s]).constantize

    @counter_hops = 100
    @delete_all_before = false
    @external_source_id_field = nil

    @use_iconv = false
    @iconv_to = 'utf-8'
    @iconv_from = 'latin1'
  end

  def delete_unexising
    self
  end

  def update_existing
    self
  end

  def use_iconv(to = nil, from = nil)
    @use_iconv = true
    @iconv_to = to if to
    @iconv_from = from if from
    self
  end

  def delete_all_before
    @delete_all_before = true
    self
  end

  def run
    puts "\nimporting %s" % @klass.name
    if @delete_all_before
      'deleting all nodes before'
      delete_all_from_nodespace
    end
    @records = read_yaml_file(@yaml_file)
    puts 'read %s records from %s' % [@records.size, @yaml_file]
    import_to_nodespace
  end

  def import_to_nodespace
    counter = 0
    @records.each do |record|
      Neo4j::Transaction.run do
        node = @klass.new
        record.each do |key, value|
          node[key] = typecast_value(value)
        end
        post_process_node(node)
      end
      output_runtime_info(counter)
      counter += 1
    end
    print counter
  end

  def output_runtime_info(counter)
    return unless (counter.to_f / @counter_hops).floor == (counter.to_f / @counter_hops)
    print("%s..." % counter)
  end

  def typecast_value(value)
    case value
    when Date, Time, DateTime
      value.to_s
    when String
      @use_iconv ? iconv_instance.iconv(value) : value
    else
      value
    end
  end

  def post_process_node(node)
    if @external_source_id_field && id_value = node[external_source_id_field]
      node[:raw_import_external_source_id] = id_value
    end
  end

  def delete_all_from_nodespace
    Neo4j::Transaction.run { @klass.all.nodes.each(&:del) }
  end

  def read_yaml_file(import_file)
    returning(records = []) do
      YAML.load_file(import_file).each do |ident, attributes|
        records << attributes
      end
    end
  end

  def iconv_instance
    @_iconv_instance ||= Iconv.new(@iconv_to, @iconv_from)
  end

end