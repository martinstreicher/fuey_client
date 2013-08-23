source 'https://rubygems.org'

gem "stately", :github => "mattsnyder/stately"

# Specify your gem's dependencies in fuey_client.gemspec
gemspec

group :test do
  if RUBY_VERSION > "1.9"
    gem "rspec-given", ">=3.0.0"
  else
    gem "rspec"
  end
end
