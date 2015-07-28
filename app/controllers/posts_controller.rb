class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:tags].present?
      @post_tags = Tag.where(id: params[:tags])
      @posts = Post.with_tags(@post_tags).order(created_at: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end
  end

  def show
    @comment = Comment.new
  end

  def new
    authorize! :create, Post
    @post = Post.new
  end

  def edit
    authorize! :update, @post
  end

  def create
    @post = Post.new(post_params)
    authorize! :create, @post
    @post.author = current_user
    if params[:preview]
      render :new
    elsif @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :update, @post
    @post.assign_attributes(post_params)
    if params[:preview]
      render :edit
    elsif @post.save
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :delete, @post
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, tag_names: [])
    end
end
