class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # 親クラスの本controllerで定義することで全てのcontrollerでsessionshelperが使える

  $days_of_the_week = %w{日 月 火 水 木 金 土} # グローバル変数：どこからでも呼び出すことができるもの
end
