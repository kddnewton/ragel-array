# frozen_string_literal: true

require_relative 'lib/ragel/array/version'

version = Ragel::Array::VERSION
repository = 'https://github.com/kddnewton/ragel-array'

Gem::Specification.new do |spec|
  spec.name          = 'ragel-array'
  spec.version       = version
  spec.authors       = ['Kevin Newton']
  spec.email         = ['kddnewton@gmail.com']

  spec.summary       = 'Provides an efficient uint8_t array'
  spec.homepage      = repository
  spec.license       = 'MIT'

  spec.metadata = {
    'bug_tracker_uri' => "#{repository}/issues",
    'changelog_uri' => "#{repository}/blob/v#{version}/CHANGELOG.md",
    'source_code_uri' => repository,
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions    = ['ext/ragel/array/extconf.rb']

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'minitest', '~> 5'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rake-compiler', '~> 1.1'
  spec.add_development_dependency 'rubocop', '~> 1.12'
end
