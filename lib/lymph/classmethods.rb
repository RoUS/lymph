#
# Namespace for Lymph-specific things, so we don't pollute the
# global or other namespaces (like Rails').
#
module Lymph

  #
  # Look up a model and return its data definition.
  #
  # @param [Class,ActiveModel,Hash,String] rdef
  #  The argument can be an instance of a model, a string naming the
  #  model, the model's class, or the model's structure as a hash.
  #
  # @return [Hash]
  #  Returns the hash of the model's definition from the
  #  Lymph::RSTRUCTURE hash.
  #
  def model_info(rdef)
    rdef	= rdef.name if (rdef.kind_of?(Class))
    rdef	= rdef.class.name if (rdef.kind_of?(Lymph::Model))
    Lymph.load_definitions
    if (rdef.kind_of?(String))
      rdef	= Lymph.definitions['models'][rdef.underscore.singularize]
    end
    return rdef
  end                           # def model_info
  module_function(:model_info)

  #
  # @return [String]
  #   Returns the name of the **model**, which is *not* the same as the
  #   record or collection.
  #
  def model_name(rdef)
    return Lymph.model_info(rdef)['name'].camelize
  end                           # def model_name
  module_function(:model_name)

  #
  # @return [Class]
  #   Returns the model class (suitable for method referencing).
  #
  def model_class(rdef)
    return eval(Lymph.model_name(rdef))
  end                           # def model_class
  module_function(:model_class)

  #
  # @return [Symbol]
  #  Returns the symbol used to identify the model's parameter list.
  #  *E.g.*, `:ticket_queue`.
  #
  def model_parameter(rdef)
    return Lymph.model_name(rdef).underscore.to_sym
  end                           # def model_parameter
  module_function(:model_parameter)

  #
  # @return [String]
  #  Returns the name of the record in the `data-definitions.yaml file.
  #  *E.g.*, `"ticket_queue"`.
  #
  def model_record_name(rdef)
    return Lymph.model_name(rdef).underscore.singularize
  end                           # def model_record_name
  module_function(:model_record_name)

  #
  # Look up a model and return a hash of all its valid and custom fields,
  #
  # @param (see #model_info) rdef
  #  The argument can be an instance of a model, a string naming the
  #  model, the model's class, or the model's structure as a hash.
  #
  # @param [String] deftype
  #  The default class for fields that don't have one explicitly
  #  denoted.
  #
  # @return [Hash]
  #  Returns a hash of valid fields for the model and their data
  #  types, from combining the +valid_fields+ and +custom_fields+
  #  value's in the record definition.
  #
  # @see Lymph#model_info
  #
  def field_types(rdef, deftype='String')
    rdef	= Lymph.model_info(rdef)
    vfl		= rdef['valid_fields']
    vfl		= Hash[vfl.map { |o| [ o, deftype ] }] if (vfl.kind_of?(Array))
    cfl		= rdef['custom_fields'] || {}
    cfl		= Hash[cfl.map { |o| [ o, deftype ] }] if (cfl.kind_of?(Array))
    results	= Hash[vfl.merge(cfl).sort]
    return results
  end                           # def field_types
  module_function(:field_types)

  #
  # @param [Class,ActiveModel,Hash,String] rdef
  #  The argument can be an instance of a model, a string naming the
  #  model, the model's class, or the model's structure as a hash.
  #
  # @param [Boolean] keysfirst
  #  If set to +false+ (the default), the list of fields will be in
  #  sorted order by name.  If set to +true+, the key fields (used
  #  to locate items through the REST interface) will appear at the
  #  beginning of the list.
  #
  # @return [Array]
  #  Returns an array of field names (the keys of the hash returned
  #  by #field_types).
  #
  # @see Lymph#field_types
  #
  def field_names(rdef, keysfirst=false)
    results	= Lymph.field_types(rdef).keys
    if (keysfirst)
      keylist	= Lymph.model_info(rdef)['keys']
      results	= results.unshift(keylist).flatten.uniq
    end
    return results.compact
  end                           # def field_names
  module_function(:field_names)

  #
  # List any fields with alias names.
  #
  # @param (see #model_info) rdef
  #  The argument can be an instance of a model, a string naming the
  #  model, the model's class, or the model's structure as a hash.
  #
  # @return [nil,Hash]
  #  Returns a hash of field names that are used in tranactions,
  #  mapped to the field names actually used in the database.
  #
  # @see Lymph#model_info
  #
  def aliased_fields(rdef)
    rdef	= Lymph.model_info(rdef)
    results	= rdef['aliased_fields']
    return results
  end                           # def aliased_fields
  module_function(:aliased_fields)

  #
  # Given a record instance or a params structure, figure out if
  # there are any aliased fields that need to be swapped about.
  #
  # @param [Mongoid::Document,ActionController::Parameters] inst
  #  The argument can be an instance of a model, a string naming the
  #  model, the model's class, or the model's structure as a hash.
  #
  # @return [Hash]
  #  Returns a hash of field names that are used in tranactions,
  #  mapped to the field names actually used in the database.
  #
  # @see Lymph#model_info
  #
  def map_aliased_fields(inst)
    if (inst.kind_of?(ActionController::Parameters))
      aliases	= Lymph.aliased_fields(inst[:rtype])
    elsif (inst.kind_of?(Lymph::Model))
      aliases 	= Lymph.aliased_fields(inst)
      aliases 	= Hash[aliases.to_a.map {|o| o.reverse}]
    else
      raise ArgumentError.new('map_aliased_fields: ' +
                              'unrecognised argument class: ' +
                              inst.class.name)
    end
    aliases.each do |old,new|
      inst[new.to_sym] = inst[old.to_sym]
      inst[old.to_sym] = nil
      inst.delete(old.to_sym)
    end
    return inst
  end                           # def map_aliased_fields
  module_function(:map_aliased_fields)

  #
  # Look up a model and return a hash of all its valid and custom fields,
  #
  # @param (see #model_info) rdef
  #  The argument can be an instance of a model, a string naming the
  #  model, the model's class, or the model's structure as a hash.
  #
  # @param [String] deftype
  #  The default class for fields that don't have one explicitly
  #  denoted.
  #
  # @return [Hash]
  #  Returns a hash of fields that can be used to locate entries in
  #  the database, and data types, from combining the `valid_fields`
  #  and `key_fields` values in the record definition.
  #
  # @see Lymph#model_info
  #
  def key_types(rdef, deftype='String')
    rdef	= Lymph.model_info(rdef)
    kfl		= Lymph.field_types(rdef, deftype).select { |k,v|
      rdef['key_fields'].include?(k.to_s.downcase)
    }
    results	= Hash[kfl.sort]
    return results
  end                           # def field_types
  module_function(:key_types)

  #
  # @param [Class,ActiveModel,Hash,String] rdef
  #  The argument can be an instance of a model, a string naming the
  #  model, the model's class, or the model's structure as a hash.
  #
  # @return [Array]
  #  Returns an array of field names (the keys of the hash returned
  #  by #key_types).
  #
  # @see Lymph#mode_info
  #
  def key_names(rdef)
    results	= Lymph.field_types(rdef).keys
    keylist	= Lymph.model_info(rdef)['key_fields']
    results	= (results & keylist).sort.compact
    return results
  end                           # def key_names
  module_function(:key_names)

  module Model

    #
    # @see Lymph#field_names
    #
    def field_names(keysfirst=false)
      return Lymph.field_names(self, keys_first)
    end                         # def field_names

    #
    # @see Lymph#model_info
    #
    def model_info
      return Lymph.model_info(self)
    end                         # def model_info

    #
    # @see Lymph#model_class
    #
    def model_class
      return self.class
    end                         # def model_class

    #
    # @see Lymph#model_name
    #
    def model_name
      return self.class.name
    end                         # def model_name

    #
    # @see Lymph#model_parameter
    #
    def model_parameter
      return Lymph.model_parameter(self)
    end                         # def model_parameter

    #
    # @see Lymph#field_types
    #
    def field_types(deftype='String')
      return Lymph.field_types(self, deftype)
    end

    #
    # @see Lymph#aliased_fields
    #
    def aliased_fields
      return Lymph.aliased_fields(self)
    end

    #
    # @see Lymph#map_aliased_fields
    #
    def map_aliased_fields
      return Lymph.map_aliased_fields(self)
    end                         # def map_aliased_fields

    #
    # Return +true+ if the specified field name(s) are valid for the
    # current model.
    #
    # Designed to be inherited by the model classes.
    #
    # @param [Array<String>] args
    #  One or more field names.
    #
    # @return [Boolean]
    #  Returns +true+ if **all** of the specified field-names are
    #  valid for the model.
    #
    def valid_fields?(*args)
      result = args & self.field_names
      return (result == args) ? true : false
    end                         # def valid_fields?

    class << self

      #
      # @private
      #
      # @!parse extend ClassMethods
      #
      def included(klass)
        klass.extend(::Lymph::Model::ClassMethods)
      end                       # def included

    end                         # Lymph::Model eigenclass

    module ClassMethods

      #
      # Define the fields and indices for a model from the record
      # definition.
      #
      # @param [String] collection
      #  Snake-case name of the collection/model.
      #
      def define_model(model)
        rdef	= Lymph.model_info(model)
        klass	= eval(model.camelize)
        unless (klass.const_defined?('ModelKeys'))
          klass.const_set('ModelKeys', rdef['key_fields'])
        end
        field_list = Lymph.field_types(rdef)
        field_list.each do |fname,ftype|
          field(fname.to_sym, :type => eval(ftype))
        end
        rdef['indices'].each do |ihash|
          index(
                {
                  ihash['key'].to_sym	=> 1,
                },
                ihash['options'] || {}
                )
        end

      end                       # def define_model

    end                         # module ClassMethods

  end                           # module Model

end                             # module Lymph
