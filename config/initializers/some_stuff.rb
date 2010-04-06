Minimal::Template.send(:include, Minimal::Template::FormBuilderProxy)
ActionView::Template.register_template_handler('rb', Minimal::Template::Handler)


require 'digest/sha1'

# ActiveSupport::Dependencies.explicitly_unloadable_constants << "Kos"
# ActiveSupport::Dependencies.load_once_paths.delete('/Users/scolex/rails/dev/dinge/dingdealer/app/kos')
