module AttendancesHelper
  
  def attendance_state(attendance) # 渡される引数は、繰り返し処理されているAttendanceモデルオブジェクト
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on # attendanceテーブルのworked_onカラムと実際の日付における当日が一致することを条件。
      return '出社' if attendance.started_at.nil? # started_atカラムがnilなら出社を返す
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil? # started_atが存在しfinished_atがnilの時に退社を返す
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    false # 勤怠データが当日ではない、または当日だが出勤時間も退勤時間も登録済の場合
  end
  
   # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
end
