# -*- encoding: utf-8 -*-
#--
#   Copyright © 2015 Ken Coar
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#++
require('lymph/railtie') if (defined?(::Rails))
require('yaml')

module Lymph

  DEFINITIONS_FILE	= 'data-definitions.yaml'
  DEFAULT_DEFINITIONS	= {
    'models'		=> [],
  }

  class << self

    attr_accessor(:definitions)

    def load_definitions
      return nil unless (defined?(::Rails))
      fpath		= ::Rails.root.join('config', DEFINITIONS_FILE).to_s
      defhash		= DEFAULT_DEFINITIONS
      if (File.exists?(fpath))
        defhash		= YAML.load(File.read(fpath))
      end
      Lymph.definitions	= defhash
    end                         # def load_definitions

  end                           # Lymph module eigenclass

  def definitions
    return ::Lymph.definitions
  end
  def definitions=(val)
    ::Lymph.definitions = val
  end

end                             # module Lymph
