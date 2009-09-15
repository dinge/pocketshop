class Concept::Value::Number < Concept::Value::Base
  is_a_neo_node do
    defaults do
      minimal_value -9999999999
      maximal_value 9999999999
    end
  end

  Defaults = HashWithIndifferentAccess.new(:minimal_value => -1000000, :maximal_value => 1000000)

  property :minimal_value, :maximal_value
end
