require('generators/lymph_generator')

module Lymph

  class ConfigGenerator < ::Lymph::Generators::Base

    include ::Lymph

    desc("Creates an empty model description file at config/#{DEFINITIONS_FILE}")
    source_root(File.expand_path('../templates', __FILE__))

    def app_name
      return ::Rails::Application.subclasses.first.parent.to_s.underscore
    end

    def create_config_file
      return template("#{DEFINITIONS_FILE}.tt", File.join('config', DEFINITIONS_FILE))
    end

  end                           # class ConfigGenerator

end                             # module Lymph
