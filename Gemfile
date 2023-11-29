source "https://rubygems.org"

ruby "3.0.6"
gem "rails", "~> 7.1.0"
gem 'bcrypt' #パスワードを適切にハッシュ化することで、万が一ネットによる攻撃を受けてデータベースからパスワードが漏洩してしまった場合でも直接パスワードが渡らず、最悪の事態を回避することができます。これによりhas_secure_passwordが使用できるようになります。。
gem 'bootstrap-sass'
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]