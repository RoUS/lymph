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

Proc.new {
  libdir		= File.join(File.dirname(__FILE__), 'lib')
  xlibdir		= File.expand_path(libdir)
  $:.unshift(xlibdir) unless ($:.include?(libdir) || $:.include?(xlibdir))
}.call
require('lymph/version')

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  if (s.respond_to?(:required_rubygems_version=))
    s.required_rubygems_version = Gem::Requirement.new('>= 0')
  end
  s.name        	= 'lymph'
  s.version     	= Lymph::VERSION
  s.authors     	= [
    'Ken Coar',
  ]
  s.email       	= [
    'kcoar@redhat.com',
  ]
  s.homepage    	= 'https://github.com/RoUS/lymph'
  s.summary     	= ("#{'%s-%s' % [ s.name, s.version, ]} - " +
                           'Rails plugin for data-driven models.')
  s.description 	= 'Description of Lymph.'
  s.license     	= 'Apache 2.0'

  s.files         	= `git ls-files -z`.split("\x0")
  #
  # These cause problems when building RPMs, and we don't need 'em in
  # the gem anyway.
  #
  s.files.delete('.yardopts')
  s.files.delete('.gitignore')
  s.test_files    	= s.files.grep(%r!^(test|spec|features)/!)
  s.has_rdoc		= true
  s.extra_rdoc_files	= [
    'README.md',
  ]
  s.rdoc_options	= [
    '--main=README.md',
    '--charset=UTF-8',
  ]
  s.require_paths 	= [
    'lib',
  ]

  #
  # Make a hash for our dependencies, since we're using some fancy
  # code to declare them depending upon the version of the
  # environment.
  #
  requirements_all	= {
    'ruby-graphviz'	=> [],
    'versionomy'	=> [
      '>= 0.4.3',
    ],
  }
  requirements_dev	= {
    'aruba'		=> [],
    'bundler'		=> [
      '~> 1.7',
    ],
    'cucumber'		=> [],
    'json'		=> [
      '>= 1.8.1',
    ],
    'rake'		=> [
      '~> 10.0',
    ],
    'rdiscount'		=> [],
    'yard'		=> [
      '>= 0.8.2',
    ],
  }

  requirements_all.each do |dep,*vargs|
    args		= [ dep ]
    args.push(*vargs) unless (vargs.count.zero? || vargs[0].empty?)
    s.add_dependency(*args)
  end

  #
  # The following bit of hanky-panky was adapted from uuidtools-2.1.3.
  #
  if (s.respond_to?(:specification_version))
    s.specification_version = 3

    if (Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0'))
      depmethod		= :add_development_dependency
    else
      depmethod		= :add_dependency
    end
  else
    depmethod		= :add_dependency
  end
  requirements_dev.each do |dep,*vargs|
    args		= [ dep ]
    args.push(*vargs) unless (vargs.count.zero? || vargs[0].empty?)
    s.send(depmethod, *args)
  end

  s.add_dependency('rails', '~> 4.2.0')

end
