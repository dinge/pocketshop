module TagHelper

  def tags
    Tag.all.nodes.map do |tag|
      tag.name
    end
  end

end