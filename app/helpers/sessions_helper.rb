module SessionsHelper
  
  def log_in(user) # 引数に渡されたuserオブジェクトでログインする
    session[:user_id] = user.id # userのidレコードをsessionに入れる
  end
  
  # 永続的セッションを記憶します（Userモデルを参照）
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄します
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # セッションと@current_userを破棄します
  def log_out
    forget(current_user)
    session.delete(:user_id) # sessionに保持しているuser情報をdeleteする
    @current_user = nil # 現在のユーザー情報が入っている@current_userもnilにする
  end
  
  # 一時的セッションにいるユーザーを返します。
  # それ以外の場合はcookiesに対応するユーザーを返します。
  def current_user
    if (user_id = session[:user_id]) # sessionにuser.idが存在しない場合nilで以下の処理されない。trueで以下が処理される。
      #if @current_user.nil? # 現在のuserがFalse(nil)の時
      @current_user ||= User.find_by(id: user_id) # Userモデル内にあるログイン中のuserのuse.idと一致するidの情報を左辺に代入する
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
  def current_user?(user)
    user == current_user
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in?
    !current_user.nil? # 現在ログインしているuserがnilではない？ nilでなかったらture、nilだったらfalse
  end
  
end