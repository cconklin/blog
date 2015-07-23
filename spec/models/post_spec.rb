require 'rails_helper'

describe Post do
  describe "validations" do
    let :valid_params do
      {
        title: "My Post",
        body: "Some content",
      }
    end
    
    it "should be valid with valid params" do
      expect(Post.new(valid_params)).to be_valid
    end
    
    it "should be invalid without a title" do
      missing_title = valid_params.except(:title)
      expect(Post.new(missing_title)).to_not be_valid
    end
    
    it "should be invalid without a body" do
      missing_title = valid_params.except(:body)
      expect(Post.new(missing_title)).to_not be_valid
    end
  end
  describe "finding by tags" do
    let(:tag) { Tag.create name: "with tag" }
    let(:post_with_tag) { Post.create title: "My Post", body: "Content" }
    let(:post_without_tag) { Post.create title: "My Post", body: "No Tag" }

    before do
      post_with_tag.tags << tag
    end

    context "with one tag" do

      it "should find posts with that tag" do
        expect(Post.with_tags([tag])).to include(post_with_tag)
      end

      it "should not find posts without that tag" do
        expect(Post.with_tags([tag])).to_not include(post_without_tag)
      end
    end

    context "with multiple tags" do
      let(:another_tag) { Tag.create name: "another tag" }

      it "should find posts with any of the passed tags" do
        post_with_tag.tags << another_tag
        expect(Post.with_tags([tag])).to include(post_with_tag)
        expect(Post.with_tags([another_tag])).to include(post_with_tag)
        expect(Post.with_tags([tag, another_tag])).to include(post_with_tag)
      end

      it "should find posts that do not have all of the passed tags" do
        expect(Post.with_tags([tag])).to include(post_with_tag)
        expect(Post.with_tags([tag, another_tag])).to include(post_with_tag)
      end

      it "should not include posts without the passed tag" do
        expect(Post.with_tags([another_tag])).to_not include(post_with_tag)
      end

    end
  end
end
