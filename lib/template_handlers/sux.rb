require 'builder'
# require 'nokogiri'

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
      sux_instance = Builder.new(template)
      yield
      sux_instance.render
    end



    class Builder

      def initialize(template)
        @template = template
        @driver = Drivers::XmlBuilder.new
        #@driver = Drivers::Nokogiri.new
        extend_template!
      end

      delegate :render, :tag, :text, :to => :@driver

      def extend_template!
        @template.extend(TagLib)
        @template.instance_variable_set(:@_sux_template_handler_instance, self)
      end



      module Drivers

        # TODO: does not work yet, this is the future
        class Nokogiri
          def initialize
            @builder = ::Nokogiri::XML::Builder.new
          end

          def render
            @builder.doc.root.to_html
          end

          def tag(tag, *args, &block)
            @builder.method_missing(tag, *args, &block)
          end

          def text(text)
            @builder.text(text.to_s)
          end

        end


        class XmlBuilder

          def initialize
            @builder = ::Builder::XmlMarkup.new(builder_options)
          end

          def render
            @builder.target!
          end

          def tag(tag, *args, &block)
            @builder.tag!(tag, *args, &block)
          end

          def text(text)
            @builder.target! << text.to_s
          end

        protected

          def builder_options
            Rails.env.development? ? { :indent => 2 } : {}
          end
        end

      end
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
            sux.tag(:#{tag}, *args, &block)
          end
        }
      end

      def sux
        @_sux_template_handler_instance
      end

      def text(text)
        sux.text(text)
      end

      alias :t :text
      alias :_ :text
      alias :__ :text

      def doctype_definiton
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


String.class_eval do
  include TemplateHandlers::Sux::Preprocessor
end
