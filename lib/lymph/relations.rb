require('lymph')

module Lymph

  class Field

    attr_accessor(:name)
    attr_accessor(:datatype)

  end                           # class Field

  class Index

    attr_accessor(:name)
    attr_accessor(:key)
    attr_accessor(:options)

    #
    # return a simple hash
    #
  end                           # class Index

  class Connexion

    attr_accessor(:type)
    attr_accessor(:local_key)
    attr_accessor(:foreign_key)
    attr_accessor(:foreign_model)

    #
    # local_key must be a Field
    #
  end                           # class Connexion

  class Model

    attr_accessor(:name)
    #
    # hash of String(fieldname)->Field
    #
    attr_accessor(:valid_fields)
    #
    # array of String (field names)
    #
    attr_accessor(:key_fields)
    #
    # Array of Index
    attr_accessor(:indices)
    attr_accessor(:connexions)

    def initialize(*args)
    end

    def add_field(name, options={})
      #
      # watch out for duplicates
      # key-ness is an option
      #
    end

    def add_index(key, options={})
      #
      # check that key field already exists or bail
      #
    end

    def add_relation(type, options={})
    end

  end                           # class Model

end                             # module Lymph
