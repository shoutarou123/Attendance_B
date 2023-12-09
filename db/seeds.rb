# coding: utf-8

# 人工ユーザー
User.create!(name: "Sample User",
             email: "sample@email.com",
             department: "管理", # 追加
             password: "password",
             password_confirmation: "password",
             admin: true) # 管理権限を持つ

# サンプルユーザー
60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  department = "サンプル" # 追加
  password = "password"
  User.create!(name: name,
               email: email,
               department: department, # 追加
               password: password,
               password_confirmation: password)
end