#require 'ostruct'

class Thing# < OpenStruct
  
  def self.find(name)
    return $db.things.findOne({:name => name})
  end
  
  def self.all
    return $db.things.findAll
  end

  def save
    # $db.things.save(:harras => 'mutter')
    $db.things.save(self)
  end

end

$db.things.setConstructor(Thing)