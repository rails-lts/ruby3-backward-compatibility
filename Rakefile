# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

ruby2_specs = 'spec/ruby2/**/*_spec.rb'
rake_task = RSpec::Core::RakeTask.new(:spec)
if RUBY_VERSION < '3'
  rake_task.pattern = ruby2_specs
else
  rake_task.exclude_pattern = ruby2_specs
end

task default: :spec
