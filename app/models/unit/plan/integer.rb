class Unit
  module Plan
    class Integer < Unit::Plan::Base
      fields :name
      fields :minimal_value, :maximal_value

      Presets = {
        :minimal_value => -9999999999,
        :maximal_value => 9999999999
      }

    end
  end
end