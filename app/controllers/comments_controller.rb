class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
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
