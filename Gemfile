source 'https://rubygems.org'

ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'activeadmin', github: 'activeadmin'
gem 'ancestry'
gem 'annotate'
gem 'attachinary', git: 'git://github.com/ThomasConnolly/attachinary.git'
gem 'autonumeric-rails'
gem 'chartkick'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'cloudinary'
gem 'country_select'
gem 'devise', '~> 4'
gem 'devise_masquerade'
gem 'draper'
gem 'email_validator'
gem 'groupdate'
gem 'hashid-rails'
gem 'jbuilder', '~> 2.5'
gem 'kaminari'
gem 'lograge'
gem 'meta-tags'
gem 'money-rails', '~>1'
gem 'newrelic_rpm'
gem 'oj'
gem 'pagarme'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'rails-assets-bootstrap-datepicker', source: 'https://rails-assets.org'
gem 'rails-assets-raphael', source: 'https://rails-assets.org'
gem 'ransack'
gem 'redis-rails'
gem 'redis-session-store'
gem 'rest-client'
gem 'rollbar'
gem 'sass-rails', '~> 5.0'
gem 'shog'
gem 'sidekiq'
gem 'simple_command'
gem 'simple_form', '~> 3.5.0'
gem 'slack-ruby-client'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'virtus', '~> 1.0.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'capybara', '~> 2.13'
  gem 'dotenv-rails'
  gem 'factory_bot'
  gem 'rspec-rails', '~> 3.6'
  gem 'selenium-webdriver'
end

group :development do
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'derailed_benchmarks'
  gem 'i18n-tasks', '~> 0.9.19'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  # gem 'i18n-debug'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-notifyjs', '0.4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
