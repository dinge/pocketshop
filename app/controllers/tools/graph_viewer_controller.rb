class Tools::GraphViewerController < ApplicationController

  uses_page do
    assets do
      additional_javascripts [
        'vendor/jit-yc',
        'visualization/rgraph_setups',
        'tools/graph_viewer', 
        'tools/graph_viewer_graph_visualization'
      ]
    end
  end


  def index
    respond_to do |wants|
      wants.html
      wants.json { render :json => GraphPresenter.new.render }
    end
  end



  class GraphPresenter
 
    def initialize
      # @start_node =  Neo4j::IndexNode.instance
      @start_node = Neo4j::IndexNode.instance.relationships.both.nodes.map.rand
      @max_iterations = 2
    end

    def render
      {
        :id => @start_node.id,
        :name => display_name(@start_node),
        # :data => {
        #   "$dim" => node_size
        # },
        :children => iterate(@start_node)
      }
    end

    def node_size(number = 0)
      # 6 - (number * 1)
      4
    end

    def iterate(parent_node, iteration = 0)
      iteration += 1
      parent_node.relationships.both.nodes.reject{ |n| n == Neo4j::IndexNode.instance }.map do |node|
        {
          :id => node.id,
          :name => display_name(node),
          # :data =>  { 
          #   "$dim" => node_size(iteration)
          # },
          :children => iteration < @max_iterations ? iterate(node, iteration) : []
        }
      end.to(10000)
    end

    def display_name(node)
      '%s - %s' % [node.classname.split(':').last, node.respond_to?(:name) ? node.name : node.id]
    end

  end


end
