class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    # 投稿数
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    
    @the_day_before = @today_book.count / @yesterday_book.count.to_f
    @the_week_before = @this_week_book.count / @last_week_book.count.to_f
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def search_count
    @user = User.find(params[:user_id])
    if params[:created_at] == nil
      @books == "日付を入力してください"
    else
      @books = @user.books.where(created_at: params[:created_at].to_date.all_day)
      render :search_count
    end
  end



  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end