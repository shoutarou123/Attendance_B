class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #有効なユーザーオブジェクトが取得でき、かつパスワードも一致すればtrue
      log_in user # ログイン後にリダイレクトする
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user # sessions_helper参照 保存されているページへ遷移　保存ページなければuser_url(user)のshowに遷移 viewで使わないから@がない
    else
      flash.now[:danger] = '認証に失敗しました。' # flash renderの組み合わせだと表示が残ってしまう
      render :new, status: :unprocessable_entity # ログインページに遷移する。status: :unprocessable_entityがないとRails7はエラー表示されない。
    end
  end
  
  def destroy
    # ログイン中の場合のみログアウト処理を実行します。
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url # トップ画面に戻る
  end
end