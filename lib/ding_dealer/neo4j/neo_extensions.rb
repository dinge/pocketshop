module Neo4j
  module Relationships

    class HasN
      def size
        to_a.size
      end

      alias :length :size
    end

  end
end
