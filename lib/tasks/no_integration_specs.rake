# frozen_string_literal: true

task :no_integration_specs

desc "Run specs without including integration specs"
RSpec::Core::RakeTask.new(:no_integration_specs) do |task|
  task.pattern = "spec/**/*_spec.rb"
  task.exclude_pattern = "spec/system/*_spec.rb"
end
