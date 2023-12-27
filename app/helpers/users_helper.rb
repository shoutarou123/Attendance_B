module UsersHelper
  
  # 勤怠基本情報を指定のフォーマットで返します。
  def format_basic_info(time)
    if time.present?
    # %は数値によって変化 .2fは値がなければ.00、値がある場合はそのまま、小数点第三位以上ある場合は第二位まで表示しそれ以降は切捨て。
    # 7時間30分を引数で渡されると(7*60)+30/60.0=7.5となる。%.2fが7.50にする。
      format("%.2f", ((time.hour * 60) + time.min) / 60.0)
    else
      "N/A"
    end
  end
end

