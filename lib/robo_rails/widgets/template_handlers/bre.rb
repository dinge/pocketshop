# the handler-class must be initialized  in environment.rb
# ActionView::Template.register_template_handler :bre, RoboRails::Widgets::TemplateHandlers::Bre
#
# e.g.
#
# in the controller
# controllers/camaigns_controller.rb
# def show
#   @campaign = Campaign.find(params[:id])
#   respond_to do |format|
#     format.html # show.html.erb
#     format.xls # show.xls.bre
#   end
# end
#

module RoboRails
  module Widgets
    module TemplateHandlers

      class Bre < ActionView::TemplateHandler

        include ActionView::TemplateHandlers::Compilable

        def self.line_offset
          3
        end

        def compile(template)
          template.source
          # <<-"END"
          #   # controller.response.content_type ||= Mime::XLS
          #   # workbook = Spreadsheet::Excel.new(excel = StringIO.new)
          #   # workbook_format = ::Connect::TemplateHandlers::Rxls::Formats.new(workbook)
          #   #{template.source}
          #   # workbook.close
          #   # excel.string
          # END
        end

      end
    end
  end
end
