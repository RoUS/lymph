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
begin
  require('bundler/setup')
rescue LoadError => exc
  puts('You must `gem install bundler` and `bundle install` to run rake tasks')
  exit(1)
end

require('rubygems')
require('fileutils')

Proc.new {
  libdir = File.join(File.dirname(__FILE__), 'lib')
  xlibdir = File.expand_path(libdir)
  $:.unshift(xlibdir) unless ($:.include?(libdir) || $:.include?(xlibdir))
}.call

require('lymph')
require('rake')

topdir 		= File.dirname(__FILE__)

include ::Rake::DSL

require('bundler/gem_tasks')

require('rake/testtask')
Rake::TestTask.new do |test|
  test.libs 	<< 'lib' << 'test'
  test.pattern	= 'test/**/test_*.rb'
  test.verbose	= true
end

require('cucumber/rake/task')
Cucumber::Rake::Task.new(:features)

task(:default => :test)

require('yard')
#require('yard-method-overrides')
YARD::Rake::YardocTask.new

Dir['tasks/**/*.rake'].each { |t| load t }
