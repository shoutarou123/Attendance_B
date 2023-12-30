class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します
    if @attendance.started_at.nil? # 始まり時間が登録されていなかったら
      if@attendance.update(started_at: Time.current.change(sec: 0).floor_to(15.minutes)) # 現在時刻を登録する。sec: 0は秒数を0にする。.floor_to(15.minutes)で15分丸め。
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil? # 出社がnilだったら
      if @attendance.update(finished_at: Time.current.change(sec: 0).floor_to(15.minutes)) # 現在時刻を登録する。sec: 0が秒数を0にする。
        flash[:info] = "お疲れさまでした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user # showアクションに遷移
  end
  
  def edit_one_month
  end
  
  def update_one_month
    begin
      ActiveRecord::Base.transaction do # トランザクションを開始します
        attendances_params.each do |id, item| # itemは各カラムの値
          attendance = Attendance.find(id)
          if item[:started_at].blank? && item[:finished_at].present? # 出社時間が空かつ退社時間が存在する時
            flash[:danger] = "出社時間が入力されていないため、更新できません。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          elsif item[:started_at].present? && item[:finished_at].blank? # 出社時間が存在するかつ退社時間が空の時
            flash[:danger] = "出社時間のみの変更はできません。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          elsif item[:started_at].present? && item[:finished_at].present? # 出社時間が存在するかつ退社時間が存在する時
            if item[:finished_at] < item[:started_at] # 出社時間の方が大きい時
              flash[:danger] = "退社時間が出社時間よりも早いです。正しい時間を入力してください。"
              redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
            else
              attendance.update!(item) # !があることでfalseでななく例外処理を返す
            end
          end
        end
      end
      flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
      redirect_to user_url(date: params[:date]) # 勤怠画面に遷移
    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return # 勤怠編集画面に遷移
    end
  end
  
  private
    # 1か月分の勤怠情報を扱います。
    def attendances_params #paramsハッシュの中のuserがキーのハッシュの中の:attendancesがキーのハッシュの中のネストされたidと各カラム
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
    # beforeフィルター
    
    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank? # ユーザー情報が空だったら、ユーザーidの情報を代入
      unless current_user?(@user) || current_user.admin? # 現在ユーザーまたは管理権限者ではない場合
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url) # トップ画面に遷移
      end
    end
end