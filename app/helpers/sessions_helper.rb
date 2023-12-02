module SessionsHelper
  
  def log_in(user) # 引数に渡されたuserオブジェクトでログインする
    session[:user_id] = user.id # userのidレコードをsessionに入れる
  end
  
  def current_user
    if session[:user_id] # sessionにuser.idが存在しない場合nilで以下の処理されない。trueで以下が処理される。
      #if @current_user.nil? # 現在のuserがFalse(nil)の時
      @current_user ||= User.find_by(id: session[:user_id]) # Userモデル内にあるログイン中のuserのuse.idと一致するidの情報を左辺に代入する
    end
  end
end
