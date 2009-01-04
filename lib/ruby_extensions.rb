# class Object
#   # Return a list of methods defined locally for a particular object.  Useful
#   # for seeing what it does whilst losing all the guff that's implemented
#   # by its parents (eg Object).
#   def local_methods(obj = self)
#     (obj.methods - obj.class.superclass.instance_methods).sort
#   end
# end



class Object
  
  def lp(message)
    $stderr.puts "=" * 100
    $stderr.puts message
    $stderr.puts "=" * 100
  end
  
end