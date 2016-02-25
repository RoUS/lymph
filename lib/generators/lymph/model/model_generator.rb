# -*- coding: utf-8 -*-
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

require('generators/lymph_generator')

module Lymph

  class ModelGenerator < ::Lymph::Generators::NamedBase

    include ::Rails::Generators::ModelHelpers

    argument(:attributes,
             {
               :type	=> :array,
               :default	=> [],
               :banner	=> 'field[:type][:index] field[:type][:index]',
             })
    hook_for(:orm, :required => true)
    check_class_collision
    class_option(:parent,
                 :type		=> :string,
                 :desc 		=> 'The parent class for the generated model')
    class_option(:indices,
                 :type 		=> :boolean,
                 :default 	=> true,
                 :desc 		=> 'Add indices for :references and "belongs_to columns')

    desc("Creates a model and adds it to config/#{DEFINITIONS_FILE}")
    source_root(File.expand_path('../templates', __FILE__))

    def parent_class_name
      options[:parent] || '::ActiveRecord::Base'
    end                         # def parent_class_name
#    protected(:parent_class_name)

    def app_name
      ::Rails::Application.subclasses.first.parent.to_s.underscore
    end                         # def app_name

    def update_definitions_file
      datafile			= File.join('config', DEFINITIONS_FILE)
      self.definitions		= File.exist?(datafile) ? YAML.load(File.read(datafile)) : {}
      self.definitions['models']	||= {}
      models			= self.definitions['models']
      cx_array			= []
      indices			= []
      key_fields		= []
      valid_fields		= {}
      newmodel			= {
        'valid_fields'		=> valid_fields,
        'key_fields'		=> key_fields,
        'indices'		=> indices,
        'connexions'		=> cx_array,
        'aliased_fields' 	=> [],
      }
      attributes.each do |attr|
        if ([:references].include?(attr.type))
          fname			= attr.name + '_id'
          ftype			= 'integer'
          connector		= true
        else
          fname			= attr.name
          ftype			= attr.type.to_s
          connector		= false
        end
        valid_fields[fname] 	= ftype
        if (attr.has_index? || attr.attr_options[:index])
          key_fields		<< fname
          indices		<< {
            'key'		=> fname,
            'options'		=> {
              :unique		=> attr.has_uniq_index?,
            },
          }
        end
        if (connector)
          case (attr.type)
          when :references
            cx			= {
              'key'		=> fname,
              'relation'      	=> :belongs_to,
              'foreign_model' 	=> attr.name,
              'foreign_key'   	=> 'id',
              'options'		=> {},
            }
            valid_fields['id'] = 'integer' unless (valid_fields.key?('id'))
            key_fields		|= [ 'id' ]
            unless (indices.any? { |i| i['key'] == 'id' })
              indices		<< {
                'key'		=> 'id',
                'options'	=> {
                  :unique	=> true,
                },
              }
            end
            rmodel		= (models[attr.name] ||= {})
            rmodel['valid_fields'] ||= {}
            rmodel['valid_fields']['id'] = 'integer' unless (rmodel['valid_fields'].key?('id'))
            rmodel['key_fields'] ||= []
            rmodel['key_fields'] |= [ 'id' ]
            rmodel['indices']	||= []
            unless (rmodel['indices'].any? { |i| i['key'] == 'id' })
              rmodel['indices']	<< {
                'key'		=> 'id',
                'options'	=> {
                  :unique	=> true,
                },
              }
            end
            rcx			= (rmodel['connexions'] ||= [])
            unless (rcx.any? { |o| o['key'] == ((file_name + '_id') && (o['relation'] == :has_one)) })
              rcx		<< {
                'key'		=> file_name + '_id',
                'relation'	=> :has_one,
                'foreign_model'	=> file_name,
                'foreign_key'	=> 'id',
              }
            end
          end
          if (attr.attr_options[:polymorphic])
            cx['options']['polymorphic'] = true
          end
          cx_array		<< cx
        end
      end
      models[file_name] = newmodel
      template('updated-definitions.yaml.tt', datafile, :force => true, :verbose => false)
    end                         # def update_definitions_file

    def create_model_file
      template('model.rb.tt', File.join('app', 'models', class_path, "#{file_name}.rb"))
    end

    hook_for(:test_framework)

  end                           # class ModelGenerator

end                             # module Lymph
