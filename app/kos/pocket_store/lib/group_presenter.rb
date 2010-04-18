module Kos::PocketStore::GroupPresenter

  def to_public_pocket_ui
    map do |group|
      { :id           => group.neo_id,
        :title        => group.title,
        :image_path   => group.image_path,
        :item_ids     => group.public_items.map { |item| item.neo_id } }
    end
  end

end