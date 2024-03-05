# coding: utf-8
require_relative 'lib/cover_my_meds/version'

Gem::Specification.new do |spec|
  spec.name          = "cover_my_meds"
  spec.version       = CoverMyMeds::VERSION
  spec.authors       = ["Justin Rolston", "Mark Lorenz", "Dan Sajner", "Chad Cunningham", "Mike Gee", "Brandon Joyce", "Ryan Kowalick", "Shaun Hardin", "Jay Bobo", "Zach Serafini", "Rachel Twyford", "Ryan Stocker", "Corey Woodcox", "Nathan Demick", "Ryan Bone", "Ben Beckwith"]
  spec.email         = ["jrolston@covermymeds.com", "mlorenz@covermymeds.com", "dsajner@covermymeds.com", "ccunningham@covermymeds.com", "mgee@covermymeds.com", "bjoyce@covermymeds.com", "rkowalick@covermymeds.com", "shardin@covermymeds.com", "jbobo@covermymeds.com", "zserafini@covermymeds.com", "rtwyford@covermymeds.com", "rstocker@covermymeds.com", "cwoodcox@covermymeds.com", "ndemick@covermymeds.com", "rbone@covermymeds.com", "bbeckwith@covermymeds.com"]

  spec.summary       = %q{CoverMyMeds Public API}
  spec.description   = %q{The public version of CoverMyMeds API}
  spec.homepage      = "https://github.com/covermymeds/cover_my_meds"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-junklet"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "railties"

  spec.add_runtime_dependency "faraday", "~> 2.9.0"
  spec.add_runtime_dependency "faraday-follow_redirects", "~> 0.3.0"
  spec.add_runtime_dependency "faraday-multipart", "~> 1.0.4"
  spec.add_runtime_dependency "faraday-typhoeus", "~> 1.1.0"
  spec.add_runtime_dependency "mime-types", "~> 3.5.2"
  spec.add_runtime_dependency "hashie", "~> 5.0.0"
  spec.add_runtime_dependency "activesupport", "~> 7.0.8"
end
