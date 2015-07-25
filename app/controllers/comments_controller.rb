class CommentsController < ApplicationController

  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.author = current_user
    @presenter = PostPresenter.new(@post)
    if @comment.save
      redirect_to @post, notice: 'Comment was successfully created.'
    else
      render "posts/show"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to @post, notice: 'Comment was successfully destroyed.'
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end
