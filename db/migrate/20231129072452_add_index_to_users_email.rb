class AddIndexToUsersEmail < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :email, unique: true #usersテーブルのemailカラムにindexを追加し一意性オプションも追加している
  end
end