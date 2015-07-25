class CommentPresenter < SimpleDelegator
  def initialize(comment)
    @comment = comment
    super(comment)
  end
  def author
    super.name
  end
  def replies
    super.each do |reply|
      presenter = CommentPresenter.new(reply)
      yield presenter
      presenter.replies do |deep_reply|
        yield deep_reply
      end
    end
  end
  def reply_to
    @comment.comment.author.name
  end
  def subreply?
    @comment.comment && @comment.comment.reply?
  end
end