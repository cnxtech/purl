source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use sqlite3 as the database (during local development)
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# JS Runtime. See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer'
# A gem for simple rails environment specific config
gem 'config'
# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# CanCanCan is an authorization Gem for rails
gem 'cancancan', '~> 1.10'

# Use Honeybadger for exception reporting
gem 'honeybadger'

# Use okcomputer to monitor the application
gem 'okcomputer'

gem 'mods_display', '~> 0.4'
gem 'htmlentities'
gem 'dor-rights-auth'
gem 'bootstrap-sass'
gem 'retina_tag'
gem 'faraday'
gem 'addressable'
gem 'tophat'
gem 'rails-file-icons'
gem 'sul_styles', '~> 0.3'
gem 'iiif-presentation', github: 'sul-dlss/osullivan', branch: 'uv-v3'
gem 'dalli'

group :production do
  gem 'newrelic_rpm'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # RSpec for testing
  gem 'rspec-rails', '~> 3.0'

  # Capybara for feature/integration tests
  gem 'capybara'

  # factory_girl_rails for creating fixtures in tests
  gem 'factory_girl_rails'

  # Poltergeist is a capybara driver to run integration tests using PhantomJS
  gem 'poltergeist'

  # Database cleaner allows us to clean the entire database after certain tests
  gem 'database_cleaner'

  # Rubocop is a static code analyzer to enforce style.
  gem 'rubocop', '= 0.46.0', require: false

  # scss-lint will test the scss files to enfoce styles
  gem 'scss-lint', require: false

  # Coveralls for code coverage metrics
  gem 'coveralls', require: false

  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', group: :test, require: false
end

gem 'lograge'

# Use Capistrano for deployment
group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano-shared_configs'
  gem 'dlss-capistrano'
end
