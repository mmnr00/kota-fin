source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'


gem 'rails', '~> 5.2.1'
gem 'sass', '~> 3.5.2'
gem 'roo'
gem 'devise'

## for styling

#gem 'twitter-bootstrap-rails'
gem 'jquery-rails'
gem 'bootstrap'
#gem 'sassc-rails', '~> 2.0.0'
gem 'font-awesome-sass'
# gem 'popper_js', '~> 1.14.7'

gem 'puma', '~> 3.11'
gem 'httparty'
gem 'chartkick'
gem 'pg', '~>0.11'
gem 'sinatra', github: 'sinatra/sinatra'

# gem 'execjs'
# gem 'therubyracer'
# gem "less-rails"
gem 'wicked_pdf'


gem 'carrierwave'
gem 'mini_magick'
gem 'fog'

gem 'rubyzip', '>= 1.2.1'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'
gem 'twilio-ruby'
gem 'sendgrid-ruby'



gem 'bootstrap-sass'
gem 'font-awesome-rails'

gem 'uglifier'


gem 'coffee-rails', '~> 4.2'

gem 'turbolinks', '~> 5.2.0'

gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  #gem 'sqlite3'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #gem 'sqlite3'
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'wkhtmltopdf-binary-edge'
  
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  #gem 'sqlite3'
end

group :production do
  #gem 'pg', '~>0.11' 
  #gem 'sqlite3'
  #gem 'wkhtmltopdf-heroku'
  gem 'wkhtmltopdf-heroku', '2.12.5.0'
end



# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
