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
end
