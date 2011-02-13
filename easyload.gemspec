# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'easyload/version'

Gem::Specification.new do |s|
  s.name        = 'easyload'
  s.version     = Easyload::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ian MacLeod']
  s.email       = ['ian@nevir.net']
  s.homepage    = ''
  s.summary     = 'A recursive and opinionated alternative to autoload.'
  s.description = 'An alternative to autoload that relies on your project\'s directory structure to determine its module hierarchy, recursively.'

  s.rubyforge_project = 'easyload'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_development_dependency('rspec', ['~> 2.5.0'])
end
