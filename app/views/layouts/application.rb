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
    render_stylesheets
    render_other_header_informations
    render_javascripts
  end

  def render_html_body
    # a '', :name => :top
    div :id => :page do

      div :id => :header do
        raw_link_to('&#8734;&#9733;&#9762;&#9764;', root_path, :id => :logo, :accesskey => 'h', :title => :home)
        image_tag('ajax_loading_indicator_arrows.gif',
          :size => '20x20', 
          :id => :ajax_loading_indicator, 
          :style => 'display:none;')
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

# if Me.someone? && !@discard_collection_control

  def render_javascripts
    javascript_include_tag Javascripts
    if controller.respond_to?(:page_env)
      unless (additional_javascripts = controller.page_env.assets.additional_javascripts).blank?
        [additional_javascripts].flatten.each do |javascript|
          javascript_include_tag javascript
        end
      end
    end
  end

  def render_stylesheets
    stylesheet_link_tag Stylesheets
    if controller.respond_to?(:page_env)
      unless (additional_stylesheets = controller.page_env.assets.additional_stylesheets).blank?
        [additional_stylesheets].flatten.each do |stylesheet|
          stylesheet_link_tag stylesheet
        end
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