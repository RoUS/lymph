require('lymph')
module Lymph

  module Generators

    class Base < ::Rails::Generators::Base

      include ::Lymph

    end                         # class Base

    class NamedBase < ::Rails::Generators::NamedBase

      include ::Lymph

    end                         # class NamedBase

  end                           # module Generators

end                             # module Lymph
