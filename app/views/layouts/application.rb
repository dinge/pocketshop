class Views::Layouts::Application < Views::Widgets::Base

  Javascripts = %w(prototype effects dragdrop controls slider application elbe vendor/livepipe/livepipe vendor/livepipe/tabs)
  Stylesheets = %w(application navigations sidebar widgets form table tabs) # new


  def content
    instruct
    html do
      head do
        render_html_head
      end
      body do
        render_html_body
      end
    end
  end


private

  def render_html_head
    render_javascripts
    render_stylesheets
    render_other_header_informations
  end

  def render_html_body
    # a '', :name => :top
    div :id => :page do

      div :id => :header do
        raw_link_to('&#8734;&#9733;&#9762;&#9764;', root_path, :id => :logo, :accesskey => 'h', :title => :home)
        render_main_navigation
      end

      div :id => :main do
        div :id => :content do
          render_flash_message
          render_content
        end
        div :id => :sidebar do
          render_sidebar
        end
        hr :class => :clearfix
      end

      div :id => :footer do
        render_footer
        hr :class => :clearfix
      end

      link_to_top

    end
  end

  # def render_html_body
  #   div :class => :document do
  #     render_main_navigation        if Me.someone?
  #     render_collection_control     if Me.someone? && !@discard_collection_control
  #     render_flash_message
  #     div :class => :content do
  #       div :class => :scope do
  #         render_content
  #         render_scope_navigation   if Me.someone?
  #       end
  #     end
  #     render_footer                 if Me.someone?
  #   end
  # end



  def render_javascripts
    javascript_include_tag Javascripts
    unless (additional_javascripts = controller.rest_env.assets.additional_javascripts).blank?
      [additional_javascripts].flatten.each do |javascript|
        javascript_include_tag javascript
      end
    end
  end

  def render_stylesheets
    stylesheet_link_tag Stylesheets
    unless (additional_stylesheets = controller.rest_env.assets.additional_stylesheets).blank?
      [additional_stylesheets].flatten.each do |stylesheet|
        stylesheet_link_tag stylesheet
      end
    end
  end

  def render_other_header_informations
    meta :"http-equiv" => 'Content-Type', :content => 'text/html; charset=utf-8'
    title 'dingdealer'
  end

  def render_main_navigation
    widget Views::Widgets::Navigation::MainNavigationWidget.new
  end

  # def render_collection_control
  #   widget Views::Widgets::Gizmo::CollectionControlWidget.new
  # end

  def render_flash_message
    flash_message
  end

  # overwrite this
  def render_content
    p 'nothing to render'
  end

  def render_sidebar
    widget Views::Widgets::Gizmo::CollectionControlWidget.new
    widget Views::Widgets::Navigation::ScopeNavigationWidget.new
  end

  def render_footer
    widget Views::Widgets::Navigation::FooterNavigationWidget.new
  end

end