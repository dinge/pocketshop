class Thing < XGen::Mongo::Base
  collection_name :things
  fields :name, :created_at, :updated_at, :version

  works_with_dynamic_attributes

end
