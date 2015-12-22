# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cover_my_meds/version'

Gem::Specification.new do |spec|
  spec.name          = "cover_my_meds"
  spec.version       = CoverMyMeds::VERSION
  spec.authors       = ["Justin Rolston", "Mark Lorenz", "Dan Sajner", "Chad Cunningham", "Mike Gee", "Brandon Joyce", "Ryan Kowalick", "Shaun Hardin", "Jay Bobo", "Zach Serafini", "Rachel Twyford", "Ryan Stocker", "Corey Woodcox", "Nathan Demick", "Ryan Bone", "Ben Beckwith"]
  spec.email         = ["jrolston@covermymeds.com", "mlorenz@covermymeds.com", "dsajner@covermymeds.com", "ccunningham@covermymeds.com", "mgee@covermymeds.com", "bjoyce@covermymeds.com", "rkowalick@covermymeds.com", "shardin@covermymeds.com", "jbobo@covermymeds.com", "zserafini@covermymeds.com", "rtwyford@covermymeds.com", "rstocker@covermymeds.com", "cwoodcox@covermymeds.com", "ndemick@covermymeds.com", "rbone@covermymeds.com", "bbeckwith@covermymeds.com"]

  spec.summary       = %q{CoverMyMeds Public API}
  spec.description   = %q{The public version of CoverMyMeds API}
  spec.homepage      = "https://github.com/covermymeds/cover_my_meds"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", ">= 3.2"
  spec.add_development_dependency "rspec-junklet", ">= 2.0"
  spec.add_development_dependency "webmock", "~> 1.11"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "railties"

  spec.add_runtime_dependency "rest-client", "~> 1.6"
  spec.add_runtime_dependency "hashie", ">= 2.0.2"
  spec.add_runtime_dependency "settingslogic"
  spec.add_runtime_dependency "activesupport"
end
