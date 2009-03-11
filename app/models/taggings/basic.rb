class Taggings::Basic
  is_a_neo_relation do
    db.meta_info = true
  end

  property :name

end
