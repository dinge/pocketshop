class Views::Layouts::Application < Views::Widgets::Base

  def content
    instruct

    html do

      head do
        render_javascripts
        render_stylesheets
        render_other_header_informations
      end

      body do
        div :class => :document do
          render_main_navigation        if Me.someone?
          render_collection_control     if Me.someone? && !@discard_collection_control
          render_flash_message
          div :class => :content do
            div :class => :scope do
              render_content
              render_scope_navigation   if Me.someone?
            end
          end
          render_footer                 if Me.someone?
        end
      end

    end

  end



  def render_javascripts
    javascript_include_tag :defaults, 'slider', 'elbe'
  end

  def render_stylesheets
    stylesheet_link_tag 'application', 'widgets', 'form'
  end

  def render_other_header_informations
    meta :"http-equiv" => 'Content-Type', :content => 'text/html; charset=utf-8'
    title 'dingdealer'
  end

  def render_main_navigation
    a '', :name => :top
    widget Views::Widgets::Navigation::MainNavigationWidget.new
  end

  def render_collection_control
    widget Views::Widgets::Gizmos::CollectionControlWidget.new
  end

  def render_flash_message
    flash_message
  end

  # overwrite this
  def render_content
    p 'no content to render'
  end

  def render_scope_navigation
    widget Views::Widgets::Navigation::ScopeNavigationWidget.new
  end

  def render_footer
    hr :style => 'clear: both;'
    widget Views::Widgets::Navigation::FooterNavigationWidget.new
  end

end