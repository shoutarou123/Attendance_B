class Attendance < ApplicationRecord
  belongs_to :user # userモデルと1:1の関係
  
  validates :worked_on, presence: true # 日付存在していること
  validates :note, length: { maximum: 50 } # 備考50文字以内
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at # オリジナルメソッドのバリデーション
  
  def finished_at_is_invalid_without_a_started_at # オリジナルメソッド
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present? # 出勤時間が空白かつ退勤時間が空白ではないときにメッセージ表示
  end
end
