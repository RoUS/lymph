# Lymph

[![Gem Version](https://badge.fury.io/rb/lymph.svg)](http://badge.fury.io/rb/lymph)

`Lymph` is a plugin for Ruby on Rails that aims to keep all your
model structures and relationships described in a `YAML` file,
obviating the need for manual editing and remembering all the
eyes to dot and teas to cross.

* **Note:** Lymph is still very much a work in progress, and needs work
to correctly handle migrations and relationships!*

`Lymph` includes a model generator for prototyping a model description
and creating the basic *`model`*`.rb` file; maintaining the description
in the `config/data-definitions.yaml` file should (eventually) be all
that's needed thenceforth.

`Lymph` also includes a Rake task that generates a GraphViz `.dot` file
showing how your models are interrelated.

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem('lymph')
```

And then execute:

    $ bundle

## Usage

```bash
#
# Create an empty definitions file.
#
$ bundle exec rails generate lymph:config --force

#
# Delete any models in the description file, and reset the description
# file itself.
#
$ bundle exec rake lymph:reset

#
# Generate a model using `lymph`.
#
$ bundle exec rails generate lymph:model customer \
    name:string \
    custnum:string \
    address:text \
    phone_w:string

#
# Generate a GraphViz file showing the relationships between the models.
#
$ bundle exec rake lymph:graph
```

## Sample model file generated with `lymph:model`

```ruby
class Zed << ::ActiveRecord::Base

  include ::Lymph::Model

  define_model('Zed')

end                             # class Zed
```

## TODO

1. Add Rake task to rebuild all model files from the YAML descriptions.
1. Hook into and create migrations as the descriptions change.
1. Hook into migration rollback and propagate it to the description file.
1. Get a handle on all the relations and how they need to appear in the description file.
1. Include the relationship setup in the `#define_model` method so they
   don't need to be maintained by hand in the model file if they change.
1. Provide a way to specify a different file than `data-definitions.yaml`.
1. Use whatever Rails is using for the `id` field rather than hard-coded `id`.

## BUGS

1. Generation of indices is not 100% reliable.
1. Generated model classes are not correctly inheriting `::ActiveRecord::Base`.

## Contributing

1. Fork it ( https://github.com/RoUS/lymph/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

`Lymph` is copyright © 2016 by Ken Coar, and is made available
under the terms of the Apache Licence 2.0:

```
   Copyright © 2016 Ken Coar

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```
