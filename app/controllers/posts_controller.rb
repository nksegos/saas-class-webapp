class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_and_authorize_post, only: [:edit, :update, :destroy]

  def index
    if params[:search].present?
      search_query = "%#{params[:search]}%"
      @posts = Post.where("title LIKE ? OR content LIKE ?", search_query, search_query).order(created_at: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully destroyed."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    # Permit title, content, and choose an existing category
    params.require(:post).permit(:title, :content, :category_id)
  end

  def set_and_authorize_post
    @post = Post.find(params[:id])
    unless @post.user == current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end

end
