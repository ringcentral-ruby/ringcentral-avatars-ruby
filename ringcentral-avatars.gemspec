lib = 'ringcentral-avatars'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = $1

Gem::Specification.new do |s|
  s.name        = lib
  s.version     = version
  s.date        = '2016-11-19'
  s.summary     = 'RingCentral library for auto-generating Gmail style avatars'
  s.description = 'Create RingCentral avatars using Gmail-style avatars'
  s.authors     = ['John Wang']
  s.email       = 'johncwang@gmail.com'
  s.homepage    = 'https://github.com/grokify/'
  s.licenses    = ['MIT']
  s.files       = Dir['lib/**/**/*']
  s.files      += Dir['[A-Z]*'] + Dir['test/**/*']

  s.required_ruby_version = '>= 2.2.2'

  s.add_dependency 'avatarly', '~> 1.5', '>= 1.5.0'
  s.add_dependency 'chunky_png', '~> 1.3', '>= 1.3.8'
  s.add_dependency 'faraday', '~> 0.9', '>= 0.9'
  s.add_dependency 'mime-types', '~> 3.0', '>= 3.1'
  s.add_dependency 'ringcentral_sdk', '~> 1', '>= 1.3.4'
  s.add_dependency 'ruby_identicon', '~> 0', '>= 0.0.5'

  s.add_development_dependency 'coveralls', '~> 0'
  s.add_development_dependency 'mocha', '~> 1'
  s.add_development_dependency 'rake', '~> 11'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'test-unit', '~> 3'
end
