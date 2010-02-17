class Views::Tools::PhraseMaker::PhraseCentricGraphPresenter

  def initialize(args = {})
    @start_phrase = args[:phrase]
    # @grammar_attribute = args[:grammar_attribute] || :subject
    @grammar_attribute = :subject

    @triples    = @start_phrase.triples_as_subject.to_a
    @subject    = @start_phrase
    @predicates = @triples.map{ |x| x.phrase_as_predicate }
    @objects    = @triples.map{ |x| x.phrase_as_object }
  end

  def render
    [build_subject] + build_predicates + build_objects
  end


private

  def build_subject
    Node.new(@subject).data('$dim' => 3, :grammar_attribute => :subject).adjacencies(@predicates).to_hash
  end

  def build_predicates
    @triples.map do |node|
      Node.new(node.phrase_as_predicate).data(:grammar_attribute => :predicate).adjacencies(node.phrase_as_object).to_hash
    end
  end

  def build_objects
    @objects.map do |node|
      Node.new(node).data(:grammar_attribute => :object).to_hash
    end
  end

  # def build_subject
  #   Node.new(@subject).data('$dim' => 3, :grammar_attribute => :subject).adjacencies(@predicates).to_hash
  # end
  # 
  # def build_predicates
  #   @triples.map do |node|
  #     Node.new(node.phrase_as_predicate).data(:grammar_attribute => :predicate).adjacencies(node.phrase_as_object).to_hash
  #   end
  # end
  # 
  # def build_objects
  #   @objects.map do |node|
  #     Node.new(node).data(:grammar_attribute => :object).to_hash
  #   end
  # end



  class Node

    def initialize(node)
      @node = node
      @adjacencies = []
    end

    def adjacencies(adjacencies)
      @adjacencies << adjacencies
      @adjacencies.flatten!
      self
    end

    def data(data)
      @data = data
      self
    end

    def to_hash
      {
        :id   => @node.id,
        :name => @node.name,
        :data => @data || {},
        :adjacencies => adjacencies_struct
      }
    end

  private

    def adjacencies_struct
      @adjacencies.map{ |adj| adj.id.to_s }.uniq
    end

  end

end
