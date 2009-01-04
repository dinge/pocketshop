class Thing < XGen::Mongo::Base
  collection_name :things
  fields :name, :created_at, :updated_at, :version, :rating, :tags
  works_with_dynamic_attributes


  InvisibleAttributesNames = [:_update, :_ns] #, :_id

  def visible_attributes
    symbolized_instance_variables - InvisibleAttributesNames
  end

end
