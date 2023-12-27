class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy] # 共通の@user = User.find(params[:id])をshow,edit,update,destroy,edit_basic_info,update_basic_infoアクションで使えるようにしている
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_all_users_info] # ログインユーザーじゃなければ一覧、詳細、編集、更新、削除、勤怠情報編集、勤怠情報更新できない
  before_action :correct_user, only: [:edit, :update] # 現在のユーザーは自分の情報のみ編集可
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_all_users_info] # 管理権限あるものだけdestroy,edit_basic_info,update_basic_infoアクションできる
  before_action :set_one_month, only: :show # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  
  def index
    @users = User.paginate(page: params[:page]) # 全てのユーザーUser.all→ページネーション判定できるオブジェクトへ変更を代入した複数形であるため@usersとしています
    @search_word = params[:search_word] # search_wordの文字を代入
    if @search_word.present? # search_wordの文字が存在する時
      @users = User.where("name LIKE ?", "%#{@search_word}%").paginate(page: params[:page]) # nameと部分一致したものを探して表示
    else
      @users = User.paginate(page: params[:page]) # 全部を表示
    end
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count # started_atがnilを除外したもの全てを取得しその数を代入
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
      render :new, status: :unprocessable_entity # status: :unprocessable_entity これがないとRails7はエラーメッセージ表示されない
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url # 一覧へ遷移
  end
  
  def edit_basic_info
  end
  
  def update_all_users_info
    new_basic_time = params[:basic_time].to_i
    new_work_time = params[:work_time].to_i
    
    if User.update_all(basic_time: new_basic_time, work_time: new_work_time)
      flash[:success] = "全てのユーザーの基本情報を更新しました。"
    else
      flash[:danger] = "更新は失敗しました。"
    end
    @basic_time = new_basic_time
    @work_time = new_work_time
    redirect_to users_url # 一覧へ遷移
  end
  
  private
  
    def user_params # 外部のユーザーが知る必要がないため、外部から使用できないようにしている。
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation) # requireは必要とする。permitは許可する。
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time) # 所属更新は不要なので削除
    end
end
