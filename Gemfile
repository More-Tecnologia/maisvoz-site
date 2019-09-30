source 'https://rubygems.org'

ruby '2.5.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'ancestry'
gem 'annotate'
gem 'attachinary', git: 'git://github.com/ThomasConnolly/attachinary.git'
gem 'autonumeric-rails'
gem 'aws-sdk-s3'
gem 'chartkick'
gem 'client_side_validations-simple_form'
gem 'client_side_validations'
gem 'cloudinary'
gem 'country_select', '~> 4.0'
gem 'cpf_cnpj'
gem 'datagrid'
gem 'devise_masquerade'
gem 'devise', '~> 4'
gem 'draper'
gem 'email_validator'
gem 'groupdate'
gem 'hashid-rails'
gem 'image_processing', '~> 1.0'
gem 'jbuilder', '~> 2.5'
gem 'kaminari'
gem 'lograge'
gem 'meta-tags'
gem 'mini_magick'
gem 'money-rails', '1.12'
gem 'oj'
gem 'paperclip'
gem 'pg', '~> 0.21'
gem 'puma', '~> 3.7'
gem 'pundit'
gem 'rack-attack'
gem 'rack-cors'
gem 'rails-assets-bootstrap-datepicker', source: 'https://rails-assets.org'
gem 'rails-assets-raphael', source: 'https://rails-assets.org'
gem 'rails', '~> 5.2.2.1'
gem 'ransack'
gem 'redis-rails'
gem 'redis-session-store'
gem 'rest-client'
gem 'sass-rails', '~> 5.0'
gem 'shog'
gem 'sidekiq'
gem 'simple_command'
gem 'simple_form', '~> 4.1.0'
gem 'slack-ruby-client'
gem 'strong_password', '~> 0.0.6'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'via_cep'
gem 'virtus', '~> 1.0.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

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
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.2'
  gem 'database_cleaner', '~> 1.7'
  gem 'faker', '~> 2.2', '>= 2.2.1'
  gem 'byebug', '~> 11.0', '>= 11.0.1'
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'derailed_benchmarks'
  gem 'i18n-tasks', '~> 0.9.19'
  gem 'letter_opener_web'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-nav'
  gem 'pry'
  gem 'solargraph'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring'
  gem 'web-console', '>= 3.3.0'
  # gem 'i18n-debug'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-notifyjs', '0.4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
