class ApplicationController < ActionController::Base
  protect_from_forgry with: :exception # CSRF対策
  include SeessionsHelper # 親クラスの本controllerで定義することで全てのcontrollerでsessionshelperが使える
end
