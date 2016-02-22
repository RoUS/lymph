# encoding: utf-8
require('generators/lymph_generator')
require('byebug')

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

    Proc.new {
      puts(PP.pp(self.methods.map { |o| o.to_s }.sort, ''))
    }.call
    desc("Creates a model and adds it to config/#{DEFINITIONS_FILE}")
    source_root(File.expand_path('../templates', __FILE__))

    def app_name
      ::Rails::Application.subclasses.first.parent.to_s.underscore
    end                         # def app_name

    def update_definitions_file
      debugger
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
        debugger
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
            :unique		=> attr.has_uniq_index?,
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
