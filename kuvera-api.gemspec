# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kuvera/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'kuvera-api'
  spec.version       = Kuvera::Api::VERSION
  spec.authors       = ['Ignat Zakrevsky']
  spec.email         = ['iezakrevsky@gmail.com']

  spec.summary       = 'Kuvera API wrapper'
  spec.homepage      = 'https://kuvera.io'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'oauth2', '~> 1.4'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.65'
end
