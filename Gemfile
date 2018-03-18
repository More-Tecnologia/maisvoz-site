source 'https://rubygems.org'

ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'annotate'
gem 'simple_form', '~> 3.5.0'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'virtus', '~> 1.0.5'
gem 'money-rails', '~>1'
gem 'devise', '~> 4'
gem 'email_validator'
gem 'country_select'
gem 'simple_command'
gem 'kaminari'
gem 'carrierwave', '~> 1.0'
gem 'cloudinary'
gem 'rollbar'
gem 'ransack'
gem 'autonumeric-rails'
gem 'sidekiq'
gem 'devise_masquerade'
gem 'rails-assets-bootstrap-datepicker', source: 'https://rails-assets.org'
gem 'rails-assets-raphael', source: 'https://rails-assets.org'
gem 'lograge'
gem 'shog'
gem 'activeadmin', github: 'activeadmin'
gem 'attachinary', :git => 'git://github.com/ThomasConnolly/attachinary.git'
gem 'draper'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.6'
  gem "factory_girl_rails", "~> 4.0"
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'i18n-tasks', '~> 0.9.19'
  gem 'derailed_benchmarks'
  # gem 'i18n-debug'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-notifyjs', '0.4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
