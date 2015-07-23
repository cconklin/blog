require 'spec_helper'
require_relative "../../app/presenters/post_presenter"

describe PostPresenter do
  let(:presenter) { PostPresenter.new(post) }
  
  describe "basic presentation" do
    let(:post) { double("Post", title: "My Big Fat Greek Post", body: "This is *bongos*, indeed.") }
  
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
    let(:post) { double("Post", title: "My Big Fat Greek Post", body: body) }
    
    it "colorizes code blocks" do
      expected_output = \
        "<div class=\"highlight\"><pre><span class=\"nb\">puts</span> " << 
        "<span class=\"s2\">&quot;Hello, World!&quot;</span>\n" <<
        "</pre></div>"
      expect(presenter.body).to eq(expected_output)      
    end
  end
  
end