# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w( charts.js recaptcha.js amount_cleasing.js utilities/select2.js flag-icon.css active-btn-tabs.js)
Rails.application.config.assets.precompile += %w( dashboards/* landing_page/* deposits/* click-tok-theme/* adverts/*)
Rails.application.config.assets.precompile += %w( ads/index.css )
Rails.application.config.assets.precompile += %w( ads/index.js )
Rails.application.config.assets.precompile += %w( raffles/index.css )
Rails.application.config.assets.precompile += %w( raffles/register-raffle.css )
Rails.application.config.assets.precompile += %w( raffles/winners.css )
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
