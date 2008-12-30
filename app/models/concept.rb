class Concept < XGen::Mongo::Base
  fields :name, :created_at, :updated_at, :version

  # has_one :plan
  has_many :pieces, :class_name => 'Piece'

end
