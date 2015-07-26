require 'redcarpet'
require 'pygments'

class PostPresenter < SimpleDelegator
  def initialize(post)
    super(post)
    @post = post
  end
  def body
    renderer = CustomHTML.new
    markdown = Redcarpet::Markdown.new renderer,
      fenced_code_blocks: true,
      tables: true,
      no_intra_emphasis: true
    markdown.render(super)
  end
  def tags
    if tag_names.empty?
      ["No Tags"]
    else
      tag_names
    end
  end
  def comments
    super.each do |comment|
      yield CommentPresenter.new(comment) unless comment.reply?
    end
  end
  def author
    super.name
  end
  
  def comment_count
    count = @post.comments.count
    case count
    when 0 then "No Comments"
    when 1 then "1 Comment"
    else "#{count} Comments"
    end
  end
  
end

class CustomHTML < Redcarpet::Render::HTML
  def block_code(code, language)
    Pygments.highlight(code, lexer: language)
  end

  def table(header, body)
    "<table class='table'>\n" <<
    "<thead>\n" <<
    header <<
    "</thead>\n" <<
    "<tbody>\n" <<
    body <<
    "</tbody>\n" <<
    "</table>\n"
  end

end
