class Unit < XGen::Mongo::Subobject
  fields :name, :type, :_plan, :required

  def plan=(plan)
    self.type = plan.class.to_s
    self._plan = plan
  end

  def plan
    @type.constantize.new(@_plan)
  end

end
