module PostsHelper
  def present(post)
    PostPresenter.new(post)
  end
end
