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
    renderer = HTMLwithPygments.new
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
    markdown.render(@markdown_body)
  end
end

class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Pygments.highlight(code, lexer: language)
    # "<pre>#{code.rstrip}</pre>"
  end
end
