# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/extensiontask'

Rake::ExtensionTask.new(:compile) do |ext|
  ext.name = 'ragel_array'
  ext.ext_dir = 'ext/ragel/array'
  ext.lib_dir = 'lib/ragel/array'
  ext.gem_spec = Gem::Specification.load('ragel-array.gemspec')
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

Rake::Task[:test].prerequisites << :compile

task default: :test
