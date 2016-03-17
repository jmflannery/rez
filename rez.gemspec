$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rez/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rez"
  s.version     = Rez::VERSION
  s.authors     = ["Jack Flannery"]
  s.email       = ["jmflannery81@gmail.com"]
  s.homepage    = "https://github.com/jmflannery/rez"
  s.summary     = "A resume web API"
  s.description = "An API for managing online resumes."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"
  # s.add_dependency "active_model_serializers", "~> 0.10.0.rc4"
  s.add_dependency "active_model_serializers", "~> 0.9.4"

  s.add_development_dependency "pg"
  s.add_development_dependency "minitest-rails", "~> 2.2.0"
  s.add_development_dependency "factory_girl_rails", "~> 4.6.0"
  s.add_development_dependency "faker", "~> 1.3.0"
  s.add_development_dependency "database_cleaner"
end
