module DingDealer
  class Guid

    cattr_accessor :version
    attr_reader :version

    @@version = 3

    class InvalidVersionFormat < StandardError; end
    class InvalidCoderVersion < StandardError; end
    class InvalidGuid < StandardError; end

    def initialize(version = @@version)
      self.version = version
    end

    def encode(encodable)
      encoded = case encodable
      when Hash then @versioned_coder_klass.encode(encodable.to_a.join(':'))
      # when Hash then @versioned_coder_klass.encode(encodable.to_json.gsub(' ',''))
      when String then @versioned_coder_klass.encode(encodable)
      end
      "#{encoded}v#{@version}"
    end

    def decode(decodable)
      @versioned_coder_klass.decode(decodable)
    end

    def decode_to_hash(decodable)
      HashWithIndifferentAccess[*@versioned_coder_klass.decode(decodable).split(':')]
      # HashWithIndifferentAccess.new( ActiveSupport::JSON.decode( @versioned_coder_klass.decode(decodable) ) )
    end

    def version=(version)
      begin
        @versioned_coder_klass = "#{self::class}::VersionedCoder#{version}".constantize
      rescue
        raise(InvalidCoderVersion.new("coder VersionedCoder#{version} does not exist"))
      end
      @version = version
    end


    # returns something like ['astalavista', 898] from the string "astalavistav898"
    def self.prepare_decodable_for_decoding(decodable)
      if ( decodable = decodable.split(/^(.+)v([\d]+)$/) ).size == 3 # why 3 not 2 ?
        [decodable.second, decodable.third.to_i]
      else
        raise InvalidVersionFormat.new("can't find version info in #{decodable}")
      end
    end

    def self.encode(encodable)
      new(@@version).encode(encodable)
    end

    def self.decode(decodable)
      decodable, version = prepare_decodable_for_decoding(decodable)
      new(version).decode(decodable)
    end

    def self.decode_to_hash(decodable)
      decodable, version = prepare_decodable_for_decoding(decodable)
      new(version).decode_to_hash(decodable)
    end


    # simple reverse for test stuff
    if Rails.env.test?
      class VersionedCoder1
        def self.encode(string)
          string.reverse
        end

        def self.decode(string)
          string.reverse
        end
      end
    end

  end
end

# deprecated
if Rails.env.test?
  module DingDealer
    class Guid

      # simple hex encoding
      class VersionedCoder2
        def self.encode(string)
          string.unpack('U'*string.length).collect {|c| c.to_s(16)}.to_s
        end

        def self.decode(string)
          string.scan(/\w./).map{|x| Integer("0x#{x}").chr }.to_s
        end
      end

    end
  end
end


module DingDealer
  class Guid

    # simple modified base64 encoding, slightly modified to fit rfc3548 + encoding trailing =s
    class VersionedCoder3
      def self.encode(string)
        encode_special_chars( Base64.encode64s(string) )
      end

      def self.decode(string)
        Base64.decode64( decode_special_chars( string ) )
      end

      def self.encode_special_chars(encodable)
        case encodable.tr("+/","-_")
        when /^([a-zA-Z0-9]+)==$/ then "#{$1}x"
        when /^([a-zA-Z0-9]+)=$/  then "#{$1}y"
        when /^([a-zA-Z0-9]+)$/   then "#{$1}z"
        else raise
        end
      end

      def self.decode_special_chars(decodable)
        case decodable.tr("-_","+/")
        when /^([a-zA-Z0-9]+)x$/ then "#{$1}=="
        when /^([a-zA-Z0-9]+)y$/ then "#{$1}="
        when /^([a-zA-Z0-9]+)z$/ then $1
        else raise DingDealer::Guid::InvalidGuid.new("something is wrong with #{decodable}")
        end
      end

    end

  end
end
