class Taggings::Basic
  is_a_neo_relation do
    options.meta_info = true
  end

  property :name

end
