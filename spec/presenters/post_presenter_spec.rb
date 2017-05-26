require 'spec_helper'
require_relative "../../app/presenters/post_presenter"
require_relative "../../app/presenters/comment_presenter"

describe PostPresenter do
  let(:presenter) { PostPresenter.new(post) }
  let(:post) { double("Post", title: "My Big Fat Greek Post", body: body, comments: comments, tags: []) }
  let(:comments) { [] }
  let(:body) { "A Post" }
  describe "basic presentation" do
    let(:body) { "This is *bongos*, indeed." }
  
    it "displays the posts title" do
      expect(presenter.title).to eq("My Big Fat Greek Post")
    end
  
    it "renders the posts Markdown body" do
      expect(presenter.body).to eq("<p>This is <em>bongos</em>, indeed.</p>\n")
    end
  end
  
  describe "displaying code" do
    let :body do
      "```ruby\n" <<
      "puts \"Hello, World!\"\n" <<
      "```"
    end
    
    it "colorizes code blocks" do
      expected_output = \
        "<div class=\"highlight\"><pre><span></span><span class=\"nb\">puts</span> " << 
        "<span class=\"s2\">&quot;Hello, World!&quot;</span>\n" <<
        "</pre></div>"
      expect(presenter.body).to eq(expected_output)      
    end
  end
  
  describe "displaying tables" do
    let :body do
      "Ruby | Python\n" <<
      "-----|-------\n" <<
      "One  | Two\n"
    end
    
    it "renders with bootstrap classes" do
      expected_output = \
        "<table class='table'>\n" <<
        "<thead>\n" <<
        "<tr>\n<th>Ruby</th>\n<th>Python</th>\n</tr>\n" <<
        "</thead>\n" << 
        "<tbody>\n" <<
        "<tr>\n<td>One</td>\n<td>Two</td>\n</tr>\n" <<
        "</tbody>\n" <<
        "</table>\n"
      expect(presenter.body).to eq(expected_output)
    end
  end
  
  describe "displaying comments" do
    before do
      allow(CommentPresenter).to receive(:new) do |comment|
        comment
      end
    end
    
    context "with no comments" do
      it "should not render anything" do
        expect { |b| presenter.comments(&b) }.to_not yield_control
      end
    end
    
    context "with no replys" do
      let(:comment) { double("comment", body: "Comment", replys: [], reply?: false) }
      let(:comments) { [comment] }
      it "displays the comments" do
        expect { |b| presenter.comments(&b) }.to yield_with_args(comment)
      end
    end
    
    context "with replys" do
      let(:reply) { double("reply", body: "Reply", replies: [], reply?: true) }
      let(:comment) { double("comment", body: "Comment", replies: [reply], reply?: false) }
      let(:comments) { [comment, reply] }
      it "displays only the comment with no replys" do
        expect { |b| presenter.comments(&b) }.to yield_successive_args(comment)
      end
    end
    
  end
  describe "counting comments" do
    context "with no comments" do
      let(:comments) { [] }
      it "displays 'No Comments'" do
        expect(presenter.comment_count).to eq("No Comments")
      end
      
    end
    context "with one comment" do
      let(:comment) { double("comment", body: "Comment", replies: [], reply?: false) }
      let(:comments) { [comment] }
      it "displays '1 Comment'" do
        expect(presenter.comment_count).to eq("1 Comment")
      end
    end
    context "with many comments" do
      let(:reply) { double("reply", body: "Reply", replies: [], reply?: true) }
      let(:comment) { double("comment", body: "Comment", replies: [reply], reply?: false) }
      let(:comments) { [comment, reply] }
      it "displays the comment count" do
        expect(presenter.comment_count).to eq("2 Comments")        
      end
    end
  end
end
