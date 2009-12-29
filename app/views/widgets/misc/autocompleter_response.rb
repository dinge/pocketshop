class Views::Widgets::Misc::AutocompleterResponse < Views::Widgets::Base

  after_initialize do
    @collection_proc = @block
  end

  def content
    ul do
      collection.each do |phrase|
        li { text!( helpers.highlight(phrase, filtered_search_term) ) }
      end
    end
  end

  def collection
    @collection ||= [filtered_search_term, @collection_proc.call.map(&:name)].flatten.uniq
  end

  def filtered_search_term
    @filtered_search_term ||= @search_term.to_s.strip
  end

end