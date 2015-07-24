require 'rails_helper'

describe Comment do
  describe "validations" do
    let(:valid_attributes) { {body: "This is a comment" } }
    it "is valid with valid attributes" do
      expect(Comment.new(valid_attributes)).to be_valid
    end
    it "is invalid without a body" do
      missing_body = valid_attributes.except(:body)
      expect(Comment.new(missing_body)).to_not be_valid
    end
  end
end
