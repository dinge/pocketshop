class Kos::PocketUi::DispatcherController < ApplicationController

  # respond_to :html


  def init_screen
    # view = ActionView::Base.new('path/to/your/views')
    # view.render(:file => 'foo/bar', :locals => { :local => 'local' })
    render :template => 'dispatcher_view'
  end

end