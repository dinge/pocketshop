class Unit
  is_a_neo_node :with_meta_info => true

  property :name, :definition
  index :name, :definition


  # fields :name, :type, :_plan, :required, :created_at, :updated_at
  #
  # def plan=(plan)
  #   self.type = plan.class.to_s
  #   self._plan = plan
  # end
  #
  # def plan
  #   @type.constantize.new(@_plan)
  # end
  #

end
