class Kos::PocketUi::DispatcherView < Minimal::Template
  Javascripts = %w(application)
  Stylesheets = [] # %w(application)

  def content
    render_dtd
    html :xmlns => 'http://www.w3.org/1999/xhtml', :'xml:lang' => 'de', :lang => 'de' do
      head do
        render_html_head
      end
      body :orient => 'portrait', :onorientationchange => 'setTimeout(scrollTo, 0, 0, 1);' do # landscape
        render_html_body
      end
    end
  end

private

  def render_html_head
    render_stylesheets
    render_other_header_informations
    render_ipad_specific_header_informations
    render_javascripts
  end

  def render_html_body
    javascript_tag do
      "window.addEventListener(
        'load',
        function(){
          setTimeout(scrollTo, 0, 0, 1);
        },
        false
      );"
    end


    # a '', :name => :top
    div :id => :page, 
      :style => 'width: 758px; height: 1024px; background-color: #000;' do
      
      select_date
      
      
      # div :id => :header do
      #   # raw_link_to('&#8734;&#9733;&#9762;&#9764;', root_path, :id => :logo, :accesskey => 'h', :title => :home)
      #   image_tag('ajax_loading_indicator_arrows.gif',
      #     :size => '20x20', 
      #     :id => :ajax_loading_indicator, 
      #     :style => 'display:none;')
      #   render_main_navigation
      # end
      # 
      # div :id => :main do
      #   div :id => :content do
      #     render_flash_message
      #     render_content
      #   end
      #   div :id => :sidebar do
      #     render_sidebar
      #   end
      #   hr :class => :clearfix
      # end
      # 
      # div :id => :footer do
      #   render_footer
      #   hr :class => :clearfix
      # end
    end
    p do
      "suppe"
    end
  end

# if Me.someone? && !@discard_collection_control

  def render_dtd
   raw_text do 
     '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
   end
  end

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
    title 'dingdealer'
    meta :"http-equiv" => 'Content-Type', :content => 'text/html; charset=utf-8'
  end

  def render_ipad_specific_header_informations
    meta :name => 'viewport', :content => 'width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=0;'
    # meta :name => 'viewport', :content => 'width=device-width', :'user-scalable' => 'no'
    meta :name => 'apple-mobile-web-app-capable', :content => 'yes'
    meta :name => 'apple-mobile-web-app-status-bar-style', :content => 'black-trans-lucent'
    meta :name => 'apple-touch-fullscreen', :content => 'yes'
    link :rel => 'apple-touch-startup-image', :href => '/startup.png' 
    meta :name => 'format-detection', :content => 'telephone=no'
    # link :rel => 'apple-touch-icon-precomposed', :href => '/startup.png' 
  end

  # overwrite this
  def render_content
    p 'nothing to render'
  end


end


