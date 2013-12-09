$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rez/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rez"
  s.version     = Rez::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rez."
  s.description = "TODO: Description of Rez."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency "pg"
  s.add_development_dependency "minitest-rails", "~> 0.9.2"
  s.add_development_dependency "active_model_serializers", "~> 0.8.1"
end
