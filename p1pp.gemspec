# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','p1pp.rb'])

spec = Gem::Specification.new do |s| 
  s.name = 'P1PP'
  s.version = P1pp::VERSION
  s.author = 'Mickaël Rémond'
  s.email = 'mremond@process-one.net'
  s.homepage = 'http://www.process-one.net/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'This is a command-line interface tool to ProcessOne Push Platform'
# Add your other files here if you make them
  s.files = %w(bin/p1.rb)
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.rdoc p1pp.rdoc)
  s.rdoc_options << '--title' << 'p1pp' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'p1.rb'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_dependency('blather')
  s.add_dependency('gli')
end
