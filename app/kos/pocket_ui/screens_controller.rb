class Kos::PocketUi::ScreensController < ApplicationController
  # respond_to :html, :js

  def show
    respond_to do |format|
      format.html { render :template => 'screens_view' }
      # format.js   { render :template => 'screens_view' }
    end
  end

end


# view = ActionView::Base.new('path/to/your/views')
# view.render(:file => 'foo/bar', :locals => { :local => 'local' })
