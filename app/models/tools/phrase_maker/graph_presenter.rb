class Tools::PhraseMaker::GraphPresenter
 
  def initialize(args = {})
    @phrase = args[:phrase]
    @start_role = args[:start_role]
    @end_role = @start_role == 'subject' ? 'object' : 'subject'
  end

  def render
    {
      :id => @phrase.id,
      :name => @phrase.name,
      :data => {  
        "$dim" => node_size
      },
      :children => iterate(@phrase, @start_role, @end_role, 10)
    }
  end

  def node_size(number = 0)
    # 6 - (number * 1)
    4
  end

  def iterate(phrase, start_role, end_role, max_iterations, iteration = 0)
    iteration += 1
    phrase.triples_as(start_role).map do |triple|
      {
        :id => triple.phrase_as(end_role).id,
        :name => triple.phrase_as(end_role).name,
        :data =>  {  
          "$dim" => node_size(iteration)
        },
        :children =>
          iteration < max_iterations ?
            iterate(triple.phrase_as(end_role), start_role, end_role, max_iterations, iteration) :
            []
      }
    end
  end

end
