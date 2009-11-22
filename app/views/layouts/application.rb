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
          render_main_navigation
          render_collection_control
          render_flash_message
          div :class => :content do
            div :class => :scope do
              render_content
              render_scope_navigation
            end
          end
          render_footer
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
    text! helpers.main_navigation if Me.someone?
  end

  def render_collection_control
    text! helpers.collection_control_for if Me.someone? && !@discard_collection_control
  end

  def render_flash_message
    text! helpers.flash_message
  end

  # overwrite this
  def render_content
    p 'no content to render'
  end

  def render_scope_navigation
    text! helpers.scope_navigation if Me.someone?
  end

  def render_footer
    hr :style => 'clear: both;'
    text! helpers.footer_navigation if Me.someone?
  end


end