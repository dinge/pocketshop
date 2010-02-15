class Views::Tools::PhraseMaker::Widgets::PhraseMergerWidget < Views::Widgets::Base

  def content
    div :id => :phrase_merger do
      ul do
        find_stuff.each do |phrase|
          li do 
            text! phrase.name
          end
        end
      end
    end
  end


private

  def find_stuff
    filtered_search_phrase = @phrase.name.to_s.strip
    [ "name:%s~0.1" % filtered_search_phrase,
      "name:%s*" % filtered_search_phrase ].map do |search_phrase|
      Tools::PhraseMaker::Phrase.find(search_phrase).to_a
    end.flatten.uniq.sort_by(&:name)
  end


end