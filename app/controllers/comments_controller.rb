class CommentsController < ApplicationController

  before_action :authenticate_user!
  
  def create
    authorize! :create, Comment
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
    authorize! :delete, @comment
    @comment.destroy
    redirect_to @post, notice: 'Comment was successfully destroyed.'
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body, :comment_id)
  end
end
