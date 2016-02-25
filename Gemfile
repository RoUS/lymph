#
# Bundler Gemfile for `lymph` Ruby gem
#
source('https://rubygems.org/')

#
# All the dependencies *could* be in the gemspec, but Bundler is
# remarkably stupid about gems needed *by* the gemspec.
#
#gemspec

RUBY_ENGINE	= 'ruby' unless (defined?(RUBY_ENGINE))

group(:default, :development, :test) do
  gem('bundler',	'>= 1.0.7')
  gem('ruby-graphviz')
  gem('psych')
  gem('versionomy',	'>= 0.4.4')
  gem('lymph',
      :path		=> '.')
end

group(:test, :development) do
  gem('aruba')
  gem('byebug')
  gem('cucumber')
  gem('json',		'>= 1.8.0')
  gem('rake')
  gem('simplecov',
      :require		=> false)
  gem('rdiscount')
  gem('redcarpet',	'< 3.0.0')
  gem('rdoc')
  gem('yard',		'~> 0.8.6')
end
