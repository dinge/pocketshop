module XGen
  module Mongo
    class Base

      # patches

      # adding missing id
      def update
        set_update_times
        row = self.class.collection.save(to_mongo_value.merge(:_id => id))
        if row._id.to_s != @_id.to_s
          return false
        end
        self
      end

      # using id instead of _id
      def destroy
        unless new_record?
          self.class.collection.remove({:_id => self.id})
        end
        freeze
      end


      # features

      # implemented missing attributes=() for update_attributes etc.
      # quick'n'dirty
      # def attributes=(attributes_hash)
      #   self.class.field_names.each do |field_name|
      #     if attributes_hash.keys.include?(field_name.to_s)
      #       send("#{field_name}=", attributes_hash[field_name])
      #     end
      #   end
      # end

      def attributes=(attributes_hash)
        attributes_hash.each do |attribute_name, value|
          init_ivar("@#{attribute_name}", value)
        end
      end

      def attributes
        attributes_hash = {}
        self.class.field_names.each do |field_name|
          attributes_hash[field_name.to_s] = instance_variable_get("@#{field_name}")
        end
        attributes_hash
      end

    end
  end
end