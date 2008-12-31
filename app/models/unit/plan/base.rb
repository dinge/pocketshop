class Unit
  module Plan
    class Base < XGen::Mongo::Subobject
      Presets = {}

      def initialize(row = {})
        super(row)
        set_presets
      end

      def presets
        self.class::Presets
      end

      def field_names
        self.class.field_names
      end

      protected

      def set_presets
        self.presets.each do |field_name, value|
          send("#{field_name}=", value) if send("#{field_name}").blank?
        end
      end
    end
  end
end
