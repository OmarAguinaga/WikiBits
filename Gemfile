source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1', '>= 5.1.1'


gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bcrypt'
gem 'figaro', '1.0'
gem 'factory_girl_rails', '~> 4.0'
gem 'devise'
gem 'faker', github: 'stympy/faker'
gem 'nyan-cat-formatter'
gem 'capybara'
gem 'email_spec'
gem 'selenium-webdriver'
gem 'webpacker', '~> 2.0'
gem 'pygments.rb', '~> 0.6.3'
gem 'redcarpet', '~> 3.4'
gem 'stripe'
gem "pundit"

group :production do
  gem 'pg'

end

group :development, :test do
 gem 'sqlite3'
 gem 'byebug', platform: :mri
 gem 'rspec-rails', '~> 3.0'
 gem 'rails-controller-testing'
 gem 'pry-rails'
 gem 'shoulda'
 gem 'listen'
end

group :development do
 gem 'web-console', '>= 3.3.0'
 gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
