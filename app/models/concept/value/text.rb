class Concept::Value::Text < Concept::Value::Base
  is_a_neo_node do
    defaults do
      minimal_length 1
      maximal_length 1000
    end
  end

  property :minimal_length, :maximal_length
end
