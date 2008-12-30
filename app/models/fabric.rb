class Fabric < XGen::Mongo::Base
  fields :name, :plan, :created_at, :updated_at, :version
end
