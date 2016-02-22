$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lymph/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lymph"
  s.version     = Lymph::VERSION
  s.authors     = ["Ken Coar"]
  s.email       = ["kcoar@redhat.com"]
  s.homepage    = 'http://example.com/'
  s.summary     = "Summary of Lymph."
  s.description = "Description of Lymph."
  s.license     = "Apache 2.0"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

end
