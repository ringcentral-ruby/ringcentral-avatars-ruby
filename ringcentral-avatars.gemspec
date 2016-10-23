lib = 'ringcentral-avatars'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = $1

Gem::Specification.new do |s|
  s.name        = lib
  s.version     = version
  s.date        = '2016-10-22'
  s.summary     = 'RingCentral library for auto-generating Gmail style avatars'
  s.description = 'Create RingCentral default avatars using Gmail-style initial avatars'
  s.authors     = ['John Wang']
  s.email       = 'johncwang@gmail.com'
  s.homepage    = 'https://github.com/grokify/'
  s.licenses    = ['MIT']
  s.files       = Dir['lib/**/**/*']
  s.files      += Dir['[A-Z]*'] + Dir['test/**/*']

  s.required_ruby_version = '>= 2.2.2'

  s.add_dependency 'avatarly', '~> 1.5', '>= 1.5.0'
  s.add_dependency 'faraday', '~> 0.9', '>= 0.9'
  s.add_dependency 'ringcentral_sdk', '~> 1', '>= 1.3.4'

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'test-unit'
end
