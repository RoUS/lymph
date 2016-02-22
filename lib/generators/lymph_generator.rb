module Lymph

  DEFINITIONS_FILE	= 'data-definitions.yaml'

  class << self

    attr_accessor(:definitions)

  end

  def definitions
    return ::Lymph.definitions
  end
  def definitions=(val)
    ::Lymph.definitions = val
  end

  module Generators

    class Base < ::Rails::Generators::Base

      include ::Lymph

    end                         # class Base

    class NamedBase < ::Rails::Generators::NamedBase

      include ::Lymph

    end                         # class NamedBase

  end                           # module Generators

end                             # module Lymph
