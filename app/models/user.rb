class User < ApplicationRecord
  before_save { self.email = email.downcase } #保存される際に現在のメールアドレスを小文字化する
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #正規表現
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX }, #正規表現
                    uniqueness: true #一意性
  validates :department, length: { maximum: 50 }
  has_secure_password # 1. ハッシュ化したパスワードを、データベースのpassword_digestというカラムに保存できるようになる。
                      # 2. ペアとなる仮想的なカラムであるpasswordとpassword_confirmationが使えるようになる。さらに存在性と値が一致するかどうかの検証も追加される。
                      # 3. authenticateメソッドが使用可能となる。このメソッドは引数の文字列がパスワードと一致した場合オブジェクトを返し、パスワードが一致しない場合はfalseを返す。
  validates :password, presence: true, length: { minimum: 6 }
end
