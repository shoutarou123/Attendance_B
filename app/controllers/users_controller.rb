class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # user_paramsはparams[:user]の代わりであり、userはuser情報全てを意味する
    if @user.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user # redirect_to user_url(@user) ←showアクションにリダイレクトしている
    else
      render :new
    end
  end
  
  private
  
    def user_params # 外部のユーザーが知る必要がないため、外部から使用できないようにしている。
      params.require(:user).permit(:name, :email, :password, :password_confirmation) # requireは必要とする。permitは許可する。
    end
end
