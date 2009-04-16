module My
  def my
    Me.now
  end

  def count_my(what)
    my.send(what).to_a.size
  end

  def dump_my(what)
    my.send(what).to_a.inspect
  end

  def dump_names_of_my(what)
    my.send(what).map(&:name)
  end

  def dump_classes_of_my(what)
    my.send(what).map(&:class)
  end
end