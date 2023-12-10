class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info] # 共通の@user = User.find(params[:id])をshow,edit,update,destroy,edit_basic_info,update_basic_infoアクションで使えるようにしている
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info] # ログインユーザーじゃなければ一覧、詳細、編集、更新、削除、勤怠情報編集、勤怠情報更新できない
  before_action :correct_user, only: [:edit, :update] # 現在のユーザーは自分の情報のみ編集可
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info] # 管理権限あるものだけdestroy,edit_basic_info,update_basic_infoアクションできる
  
  def index
    @users = User.paginate(page: params[:page]) # 全てのユーザーUser.all→ページネーション判定できるオブジェクトへ変更を代入した複数形であるため@usersとしています
  end
  
  def show
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # user_paramsはparams[:user]の代わりであり、userはuser情報全てを意味する
    if @user.save
      log_in @user # 保存成功後ログインする viewで使っているので@をつける
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user # redirect_to user_url(@user) ←showアクションにリダイレクトしている
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url # 一覧へ遷移
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
  end
  
  private
  
    def user_params # 外部のユーザーが知る必要がないため、外部から使用できないようにしている。
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation) # requireは必要とする。permitは許可する。
    end
    
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
      redirect_to(root_url) unless current_user?(@user) # ユーザー情報が現在のユーザーと異なる場合トップページに遷移
    end
    
    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin? # 管理権限がない場合トップ画面に遷移
    end
end
