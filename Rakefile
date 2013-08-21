require "bundler/gem_tasks"
require "rubygems"
require "rspec"
require 'pty'

def version
  FueyClient::VERSION
end

def tag_name
  "fuey_client-#{version}"
end

def tagged?
  `git tag`.split.include?(tag_name)
end

def git_clean?
  sh "git status | grep 'nothing to commit'", :verbose => false do |status|
    return status
  end
end

desc "Display the current version tag"
task :version do
  puts tag_name
end

desc "Tag the current commit with #{tag_name}"
task :tag do
  fail "Cannot tag, project directory is not clean" unless git_clean?
  fail "Cannot tag, #{tag_name} already exists." if tagged?
  sh "git tag #{tag_name}"
end

desc "Uninstall, build, and install new build locally"
task :update do
  PTY.spawn("gem uninstall fuey_client") do | reader, writer |
    writer.puts 'Y'
    puts reader.gets
  end
  puts %x(gem build fuey_client.gemspec)
  puts %x(gem install -l #{tag_name}.gem)
end

task :default do
  if RUBY_VERSION < "1.9"
    puts %(Ruby version is too old to run these tests. Tests require v1.9 or greater. You are using #{RUBY_VERSION})
  else
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new
    Rake::Task["spec"].invoke
  end
end
