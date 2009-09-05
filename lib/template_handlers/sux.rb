require 'builder'

module TemplateHandlers
  class Sux < ActionView::TemplateHandler
    include ActionView::TemplateHandlers::Compilable

    def compile(template)
      <<-"END"
        ::TemplateHandlers::Sux.render_template(self) do
          #{template.source.preprocess_template_in_sux_template_handler}
        end
      END
    end

    def self.render_template(template)
      sux_instance = Markup.new(template)
      yield
      sux_instance.builder.target!
    end


    class Markup
      attr_reader :builder

      def initialize(template)
        @template = template
        @builder  = ::Builder::XmlMarkup.new(builder_options)
        extend_template!
      end

      def builder_options
        Rails.env.development? ? { :indent => 2 } : {}
      end

      def extend_template!
        @template.extend(TagLib)
        @template.instance_variable_set(:@_sux_template_handler_instance, self)
      end


      module TagLib
        Tags = [
          :html, :head, :meta, :body, :title,
          :div, :span, :p, :a,
          :ul, :li,
          :h1, :h2, :h3, :h4, :h5, :hr,
          :dl, :dt, :dd,
          :table, :thead, :tbody, :th, :tr, :td,
          :label, :fieldset, :legend
        ]

        Tags.each do |tag|
          module_eval %Q{
            def #{tag}(*args, &block)
              sux.builder.tag!(:#{tag}, *args, &block)
            end
          }
        end

        def sux
          @_sux_template_handler_instance
        end

        def text(text)
          sux.builder.target! << text.to_s
        end

        alias :t :text
        alias :_ :text
        alias :__ :text

        def doctype_declaration
          text %q( <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> )
        end

      end

      module Preprocessor
        def preprocess_template_in_sux_template_handler
          puts "preprocess_for_sux"
          source = self.dup
          source.gsub!('****', '_')
          source
        end
      end


    end

  end
end


String.class_eval do
  include TemplateHandlers::Sux::Markup::Preprocessor
end
