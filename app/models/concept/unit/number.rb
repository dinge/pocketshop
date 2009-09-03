class Concept::Unit::Number < Concept::Unit::Base
  is_a_neo_node do
    defaults do
      minimal_value -9999999999
      maximal_value 9999999999
    end
  end

  property :minimal_value, :maximal_value

end
