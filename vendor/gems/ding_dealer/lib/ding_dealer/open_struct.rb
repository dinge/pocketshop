module DingDealer
  class OpenStruct < ::DingDealer::Struct

    def build_methods_on_method_missing(method, args, attribute)
      struct_accessor(attribute)
      send(method, *args)
    end

  end
end