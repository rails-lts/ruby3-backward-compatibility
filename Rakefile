# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

ruby2_specs = 'spec/ruby2/**/*_spec.rb'
rake_task = RSpec::Core::RakeTask.new(:spec)

if RUBY_VERSION < '3'
  rake_task.pattern = 'spec/ruby2/**/*_spec.rb'
  task default: :spec
else
  rake_task.exclude_pattern = 'spec/{ruby2,isolated}/**/*_spec.rb'

  isolated_rake_task = RSpec::Core::RakeTask.new(:isolated_specs)
  isolated_rake_task.pattern = 'spec/isolated/**/*_spec.rb'

  task default: [:spec, :isolated_specs]
end

