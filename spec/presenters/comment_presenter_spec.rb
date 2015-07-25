require 'spec_helper'
require_relative "../../app/presenters/comment_presenter"

describe CommentPresenter do
  let(:comment) { double("comment", author: double("User", name: "Joe"), body: "My Comment") }
  let(:presenter) { CommentPresenter.new(comment) }
  it "displays the author's name" do
    expect(presenter.author).to eq("Joe")
  end
  it "displays the comment body" do
    expect(presenter.body).to eq("My Comment")
  end
  describe "replies" do
    context "one-deep" do
      let(:reply1) { double("reply", body: "Reply", replies: [], reply?: true) }
      let(:reply2) { double("reply", body: "Reply", replies: [], reply?: true) }
      let(:reply3) { double("reply", body: "Reply", replies: [], reply?: true) }      
      let(:comment) { double("comment", body: "Comment", replies: [reply1, reply2], reply?: false) }
      it "displays the replies to the presented comment" do
        expect { |b| presenter.replies(&b) }.to yield_successive_args(reply1, reply2)
      end
    end
    context "many deep" do
      let(:reply1) { double("reply", body: "Reply", replies: [], reply?: true) }
      let(:reply2) { double("reply", body: "Reply", replies: [reply3], reply?: true) }
      let(:reply3) { double("reply", body: "Reply", replies: [], reply?: true) }      
      let(:comment) { double("comment", body: "Comment", replies: [reply1, reply2], reply?: false) }
      it "displays the replies to the presented comment" do
        expect { |b| presenter.replies(&b) }.to yield_successive_args(reply1, reply2, reply3)
      end      
    end
  end
end