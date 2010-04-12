class Kos::PocketUi::ScreensView < Minimal::Template

  Javascripts = %w(application jquery-1.4.2.min.js superclass supermodel underscore-min iwebkit/functions kos/pocket_ui)
  Stylesheets = %w(iwebkit/developer-style kos/pocket_ui) # %w(application)


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
    div :id => :topbar, :class => :transparent do
      div :id => :title do
        'Zeugs'
      end
      div :id => :triselectionbuttons do
        raw_text do
          '<a href="#">Gruppen</a><a href="#">Suppe</a><a href="#">Hersteller</a>'
        end
      end
    end

#     raw_text do
# ' <div class="searchbox"><form action="" method="get"><fieldset><input id="search" placeholder="search" type="text" /><input id="submit" type="hidden" /></fieldset></form></div>    '  
#     end

#     raw_text do
#       '<div id="tributton"><div class="links">
# <a href="A.html">AText</a><a href="B.html">BText</a><a href="C.html">CText</a>
# </div></div>'
#     end

    div :id => :content do
      span :class => :graytitle, :id => :graytitle do
        'loading'
      end
    end

    div :id => :footer do
    end
  end


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
    title 'pocketshop'
    meta :"http-equiv" => 'Content-Type', :content => 'text/html; charset=utf-8'
  end

  def render_ipad_specific_header_informations
    meta :name  => 'viewport',
          :content  => 'width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=0;'
    meta :name  => 'apple-mobile-web-app-capable',  :content => 'yes'
    meta :name  => 'apple-mobile-web-app-status-bar-style', :content => 'black-trans-lucent'
    meta :name  => 'apple-touch-fullscreen',        :content => 'yes'
    link :rel   => 'apple-touch-startup-image',     :href => '/startup.png'
    meta :name  => 'format-detection',              :content => 'telephone=no'
    # link :rel => 'apple-touch-icon-precomposed', :href => '/startup.png'
    # meta :name => 'viewport', :content => 'width=device-width', :'user-scalable' => 'no'
  end

  # overwrite this
  def render_content
    p 'nothing to render'
  end


end