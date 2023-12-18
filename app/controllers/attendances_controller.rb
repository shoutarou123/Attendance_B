class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します
    if @attendance.started_at.nil? # 始まり時間が登録されていなかったら
      if@attendance.update(started_at: Time.current.change(sec: 0))  # 現在時刻を登録する。sec: 0は秒数を0にする。
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil? # 出社がnilだったら
      if @attendance.update(finished_at: Time.current.change(sec: 0)) # 現在時刻を登録する。sec: 0が秒数を0にする。
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
    ActiveRecord::Base.transaction do # トランザクションを開始します
      attendances_params.each do |id, item| # itemは各カラムの値
        attendance = Attendance.find(id)
        attendance.update!(item) # !があることでfalseでななく例外処理を返す
      end
    end
    flash[:success] = "1か月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date]) # 勤怠画面に遷移
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date]) # 勤怠編集画面に遷移
  end
  
  private
    # 1か月分の勤怠情報を扱います。
    def attendances_params #paramsハッシュの中のuserがキーのハッシュの中の:attendancesがキーのハッシュの中のネストされたidと各カラム
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
end
