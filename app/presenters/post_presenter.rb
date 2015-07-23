require 'redcarpet'
require 'pygments'

class PostPresenter < SimpleDelegator
  attr_reader :title
  def initialize(post)
    super(post)
    @title = post.title
    @markdown_body = post.body
  end
  def body
    renderer = CustomHTML.new
    markdown = Redcarpet::Markdown.new renderer,
      fenced_code_blocks: true,
      tables: true,
      no_intra_emphasis: true
    markdown.render(@markdown_body)
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
