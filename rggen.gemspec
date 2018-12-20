# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rggen/version'

Gem::Specification.new do |spec|
  spec.name                   = 'rggen'
  spec.version                = RgGen::VERSION
  spec.required_ruby_version  = '>= 2.3'
  spec.authors                = ['Taichi Ishitani']
  spec.email                  = ['taichi730@gmail.com']
  spec.homepage               = 'https://github.com/taichi-ishitani/rggen'
  spec.license                = 'MIT'

  spec.summary      = 'Code generation tool for control registers in a SoC design.'
  spec.description  = <<-EOS
    RgGen is a code generator tool for SoC/IP/FPGA/RTL engineers.
    It will automatically generate source code for control/status registers, e.g. RTL, UVM RAL model, C header file, from its register map document.
    Also RgGen is customizable so you can build your specific generate tool.
  EOS

  spec.files  = `git ls-files -z`.split("\x0").reject { |f|
    f =~ %r{^(?:
      bin/setup
      |spec/.*
      |Gemfile
      |Rakefile
      |rggen.gemspec
      |.rspec
      |.rubocop_todo.yml
      |.rubocop.yml
      |.travis.yml
      |(?:.+/)*.gitignore
    )$}x
  }
  spec.bindir         = 'bin'
  spec.executables    = ['rggen']
  spec.require_paths  = ['lib']

  spec.add_runtime_dependency 'erubi'      , '>= 1.7'
  spec.add_runtime_dependency 'facets'     , '>= 3.0'
  spec.add_runtime_dependency 'roo'        , '>= 2.1.1'
  spec.add_runtime_dependency 'spreadsheet', '>= 1.0.3'

  spec.add_development_dependency 'rake'   , '>= 10.0'
  spec.add_development_dependency 'rspec'  , '>=  3.3'
  spec.add_development_dependency 'rubocop', '>=  0.35'
end
