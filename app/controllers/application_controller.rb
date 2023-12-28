class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # 親クラスの本controllerで定義することで全てのcontrollerでsessionshelperが使える

  $days_of_the_week = %w{日 月 火 水 木 金 土} # グローバル変数：どこからでも呼び出すことができるもの

  # beforeフィルター
  
  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end

 # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in? # ログインしていなければ下の処理実行
      store_location # sessions_helper参照 ページの記憶
      flash[:danger] = "ログインしてください。"
      redirect_to login_url # ログインページへ遷移
    end
  end
  
# アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) # ユーザー情報が現在のユーザーと異なる場合トップページに遷移
  end
  
# システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin? # 管理権限がない場合トップ画面に遷移
  end
  
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    @first_day = params[:date].nil?? #nilなら初日をnil以外ならその日を代入
    Date.current.beginning_of_month : params[:date].to_date# Date.current当日。beginning_of_month Railsのメソッドで当月の初日。現在の日付が月初を代入
    @last_day = @first_day.end_of_month # end_of_month 終日。つまり当月の終日になる。
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。showアクションでは使わない為ローカル変数に代入
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on) # showアクションに設定している@user = User.find(params[:id])
                                                                             # showアクションでも使用することになる為インスタンス変数に代入。worked_onの値をもとに昇順に並び替えます。
    unless one_month.count == @attendances.count # 対象の月の日数とユーザーの日数が＝ではない場合下の処理実行
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on) # 2箇所に増やしているのは実際に日付データを繰り返し処理で生成した後にも、正しく@attendances変数に値が代入されるようにするためです。
    end
  
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url # トップページに遷移
  end
end
