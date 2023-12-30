source "https://rubygems.org"

ruby "3.0.6"
gem "rails", "~> 7.1.0"
gem 'rails-i18n' # 日本語化
gem 'bcrypt' #パスワードを適切にハッシュ化することで、万が一ネットによる攻撃を受けてデータベースからパスワードが漏洩してしまった場合でも直接パスワードが渡らず、最悪の事態を回避することができます。これによりhas_secure_passwordが使用できるようになります。。
gem 'faker' # サンプルユーザー作成
gem 'bootstrap-sass'
gem 'will_paginate', '~> 3.3' # ページネーション機能追加 バージョン3.3以下じゃないと機能しない
gem 'bootstrap-will_paginate' # ページネーションデザイン調整
gem 'rounding' # 追加
# 以下のコメントアウトは8章テキストどおり実施するとアプリケーション読み込まれないためコメントアウトしたもの
# gem 'puma',         '~> 3.7'
# gem 'sass-rails',   '~> 5.0'
# gem 'uglifier',     '>= 1.3.0'
# gem 'coffee-rails', '~> 4.2'
# gem 'jquery-rails'
# gem 'turbolinks',   '~> 5'
# gem 'jbuilder',     '~> 2.5'
# gem "bootsnap", require: false # 元々入っていたgem追加してみた

# group :development, :test do
#   gem 'sqlite3'
#   gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
# end

# group :development do
  # gem 'web-console', '>= 3.3.0'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
# end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

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
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rails-flog', require: 'flog'
  gem 'rspec-rails'
  gem "factory_bot_rails"
  gem 'faker'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

group :production do
  gem 'pg', '0.20.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]