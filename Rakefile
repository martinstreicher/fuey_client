require "bundler/gem_tasks"
require "rubygems"
require "rspec"

task :default do
  if RUBY_VERSION < "1.9"
    puts %(Ruby version is too old to run these tests. Tests require v1.9 or greater. You are using #{RUBY_VERSION})
  else
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new
    Rake::Task["spec"].invoke
  end
end
