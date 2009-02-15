module ThingsHelper

  def node_meta_info(node)
    unless node.new_record?
      control_list_container :class => :node_meta_info do
        [ (node.creator.name rescue nil),
          node.created_at.to_s(:db),
          node.updated_at.to_s(:db),
          node.version ].compact
      end
    end
  end

end
