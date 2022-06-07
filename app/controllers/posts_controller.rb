class PostsController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :create]
  
  def index
    if params[:search] != nil && params[:search] != ''
        #部分検索かつ複数検索
        search = params[:search]
        @posts = Post.joins(:user).where("body LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%").where(private: false).order(created_at: :desc)
      else
        # プライベート投稿以外のすべての投稿を表示
        @posts = Post.where(private: false).order(created_at: :desc)
    end
  end
  
  def rank
    if params[:search] != nil && params[:search] != ''
        #部分検索かつ複数検索
        search = params[:search]
        @posts = Post.joins(:user).where("body LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%").where(private: false)
      else
        # プライベート投稿以外のすべての投稿を表示
        @posts = Post.where(private: 0)
    end
    
    @rank_posts = Post.all.sort {|a,b| b.liked_users.count <=> a.liked_users.count}
    
  end
  
  # 学部プライベート投稿だけを表示
  def undergraduate
    if params[:search] != nil && params[:search] != ''
        #部分検索かつ複数検索
        search = params[:search]
        @posts = Post.joins(:user).where("body LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%").where(private: 1).where(undergraduate: current_user.undergraduate).order(created_at: :desc)
      else
        @posts = Post.where(private: 1, undergraduate: current_user.undergraduate).order(created_at: :desc)
    end
  end
  
  # 学科・コースプライベート投稿だけを表示
  def course
    if params[:search] != nil && params[:search] != ''
        #部分検索かつ複数検索
        search = params[:search]
        @posts = Post.joins(:user).where("body LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%").where(private: 2).where(course: current_user.course).order(created_at: :desc)
      else
        @posts = Post.where(private: 2, course: current_user.course).order(created_at: :desc)
    end
  end

  def new
    @post = Post.new
  end
  
  def create
    post = Post.new(post_params)
    
    post.user_id = current_user.id
    
    if post.save
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      redirect_to :action => "show", :id => post.id
    else
      redirect_to :action => "new"
    end
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to action: :index
  end

  private
  def post_params
    params.require(:post).permit(:body, :image, :private, :undergraduate, :course)
  end
end
