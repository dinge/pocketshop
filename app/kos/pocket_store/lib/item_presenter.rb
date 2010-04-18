module Kos::PocketStore::ItemPresenter

  def to_public_pocket_ui
    map do |item|
      { :id               => item.neo_id,
        :title            => item.title,
        :price            => item.price,
        :image_path       => item.image_path,
        :large_image_path => item.large_image_path }
    end
  end

end