$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "drg_rotator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "drg_rotator"
  s.version     = DrgRotator::VERSION
  s.authors     = ["Damjan Rems"]
  s.email       = ["damjan.rems@gmail.com"]
  s.homepage    = "https://www.drgcms.org"
  s.summary     = "DRG Rotator: Implements rotating web element for DRG CMS. "
  s.description = "DRG Rotator implements rotating image or HTML text on DRG CMS enabled web site. It requirers Foundation library for implementing rotating web element."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'drg_cms'
  s.add_dependency 'foundation-rails'
end
