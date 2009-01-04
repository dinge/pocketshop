class Unit
  module Plan
    class Text < Unit::Plan::Base
      fields :name
      fields :minimal_length, :maximal_length

      Presets = {
        :minimal_length => 1,
        :maximal_length => 1000
      }

    end
  end
end