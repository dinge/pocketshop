class Piece < XGen::Mongo::Subobject
  
  fields :name, :type

  # attr_accessor :name
  # attr_accessor :type
  # 
  # def initialize(attributes = {}, &proc)
  #   @name = attributes[:name]
  #   @type = attributes[:type]
  #   instance_eval(&proc) if block_given?
  # end

end