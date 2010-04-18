require 'rio'
class Kos::FestivalfieberLegacy::Importer

  def self.run
    import_festivals
    import_tags
    parent::Festival.to_store
    parent::Tag.to_store
    nil
  end

  def self.festival_hash
    @festival_hash ||= (
      xml = rio('http://www.festivalfieber.de/feeds/festivals_for_pocket_shop?user=pocket_shop&password=zae2eeV2he').read
      Hash.from_xml(xml)['festivals']['festival']
    )
  end

  def self.import_festivals
    Neo4j::Transaction.run do
      parent.import_set.items.each(&:del)

      festival_hash.each do |remote_festival|
        festival = parent::Festival.new(
          :name             =>  remote_festival['name'],
          :meta_name        =>  remote_festival['meta_name'],
          :start_date       =>  remote_festival['start_date'],
          :end_date         =>  remote_festival['end_date'],
          :link             =>  remote_festival['link'],
          :visitors         =>  remote_festival['visitors'],
          :canceled         =>  remote_festival['canceled'],
          :venue_name       =>  remote_festival['venue']['name'],
          :venue_town       =>  remote_festival['venue']['town'],
          :logo_image_path  =>  remote_festival['images_paths']['logo'],
          :logo_image_path  =>  remote_festival['images_paths']['flyer'],
          :raw_import_external_source_id => remote_festival['id'].to_i
        )

        if artists = Array.wrap(remote_festival['lineup']['artists']['artist'])
          festival[:lineup] = artists.join(', ')
        end
        if tags = Array.wrap(remote_festival['tags']['tag'])
          festival[:tag_names] = tags.join('|')
        end
        parent::add_to_import_set_as_item(festival)
      end
    end
  end

  def self.import_tags
    Neo4j::Transaction.run do
      parent.import_set.groups.each(&:del)

      festival_hash.each do |remote_festival|
        Array.wrap(remote_festival['tags']['tag']).each do |remote_tag|
          if parent.import_set.groups { title == remote_tag }.empty?
            tag = parent::Tag.new(:title => remote_tag)
            parent::add_to_import_set_as_group(tag)
          end
        end
      end

    end
  end


  def self.typecast_value(value)
    case value
    when Date, Time, DateTime;  value.to_s
    else                        value
    end
  end

end