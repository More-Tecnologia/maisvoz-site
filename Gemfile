source 'https://rubygems.org'

ruby '2.7.5'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'ancestry'
gem 'annotate'
gem 'attachinary', git: 'https://github.com/ThomasConnolly/attachinary.git'
gem 'autonumeric-rails'
gem 'aws-sdk-s3'
gem 'chartkick'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'cloudinary'
gem 'country_select', '~> 4.0'
gem 'cpf_cnpj'
gem 'datagrid'
gem 'devise', '~> 4'
gem 'devise_masquerade'
gem 'draper'
gem 'email_validator'
gem 'groupdate'
gem 'hashid-rails'
gem 'httparty', '~> 0.17.1'
gem 'image_processing', '~> 1.0'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
gem 'kaminari'
gem 'lograge'
gem 'meta-tags'
gem 'mini_magick'
gem 'money-rails', '1.12'
gem 'oj'
gem 'paperclip'
gem 'paper_trail', '~> 10.3', '>= 10.3.1'
gem 'pg', '~> 0.21'
gem 'puma', '~> 3.7'
gem 'pundit'
gem 'rack-attack'
gem 'rack-cors'
gem 'rails', '~> 5.2.2.1'
gem 'rails-assets-raphael', source: 'https://rails-assets.org'
gem 'rails-ujs', '~> 0.1.0'
gem 'ransack'
gem 'redis-rails'
gem 'redis-session-store'
gem 'rest-client'
gem 'rqrcode', '~> 1.1', '>= 1.1.1'
gem 'sass-rails', '~> 5.0'
gem 'shog'
gem 'sidekiq'
gem 'simple_command'
gem 'simple_form', '~> 4.1.0'
gem 'slack-ruby-client'
gem 'social-share-button'
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
  gem 'byebug', '~> 11.0', '>= 11.0.1'
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner', '~> 1.7'
  gem 'dotenv-rails'
  gem 'factory_bot'
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.2'
  gem 'faker', '~> 2.2', '>= 2.2.1'
  gem 'rspec-rails', '~> 3.6'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'derailed_benchmarks'
  gem 'guard', '~> 2.15'
  gem 'guard-livereload', require: false
  gem 'htmlbeautifier', require: false
  gem 'i18n-tasks', '~> 0.9.19'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry'
  gem 'pry-nav'
  gem 'rubocop', require: false
  gem 'rubocop-rails', '2.14.2', require: false
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-notifyjs', '0.4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
