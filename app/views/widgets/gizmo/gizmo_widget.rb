class Views::Widgets::Gizmo::GizmoWidget < Views::Widgets::Base

  after_initialize do
  end

  def content
    send("render_#{ @state || :show }")
  end


private

  def render_show
    fieldset do
      legend do
        link_to_gizmo(@gizmo, :edit)
        widget Views::Widgets::Gizmo::ControlWidget.new(:gizmo => @gizmo)
      end
      dl do
        field_names.each do |field_name|
          dt field_name
          dd present_field(@gizmo.send(field_name))
        end
      end
    end
  end

  def render_index
    # @gizmos.each { | gizmo | gizmo_widget(:gizmo => gizmo, :state => :show) }

    table do
      caption helpers.pluralize(@gizmos.size, @gizmos.first.class.model_name)
      tbody do
        @gizmos.each do |gizmo|
          tr do
            td do
              widget Views::Widgets::Gizmo::ControlWidget.new(:gizmo => gizmo)
            end
            td do
              link_to_gizmo(gizmo)
            end
          end
        end
      end
    end

  end

  def render_edit
    render_gizmo_or_auto_form
  end

  def render_new
    render_gizmo_or_auto_form
  end



  def render_gizmo_or_auto_form
    # form_widget_path = "/#{controller.controller_path}/form_widget.rb"
    form_widget_path = (@gizmo.class.model_name.split("::").map{ |x| x.underscore.pluralize } << 'form_widget.rb').join('/')
    if ActiveSupport::Dependencies.search_for_file(form_widget_path)
      widget "Views::#{controller.controller_path.camelize}::FormWidget".constantize.new(:gizmo => @gizmo)
    else
      important_message 'Autoform is not implemented!', 'Rendering standard show view.' 
      render_show unless @state == 'new'
    end
  end

  def field_names
    filter_field_names(@gizmo.class.property_names) #, options
  end

  def filter_field_names(field_names, options = {})
    if except = options[:except]
      field_names - except
    elsif only = options[:only]
      only
    else
      field_names
    end
  end

  def present_field(value)
    case value
    when DateTime;  value.in_time_zone
    else            value
    end
  end

end