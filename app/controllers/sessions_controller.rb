class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #有効なユーザーオブジェクトが取得でき、かつパスワードも一致すればtrue
      log_in user # ログイン後にリダイレクトする
      redirect_to user # user_url(user)のshowに遷移 viewで使わないから@がない
      
    else
      flash.now[:danger] = '認証に失敗しました。' # flash renderの組み合わせだと表示が残ってしまう
      render :new # ログインページに遷移する
    end
  end
end
