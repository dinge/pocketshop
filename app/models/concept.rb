class Concept < XGen::Mongo::Base
  collection_name :concepts
  fields :name, :created_at, :updated_at, :version
  has_many :units, :class_name => 'Unit'
  # has_many :embedded_concepts, :class_name => 'Concept'
end