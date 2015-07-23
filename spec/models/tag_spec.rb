require 'rails_helper'

describe Tag do
  describe "validations" do
    let(:valid_attributes) { { name: "My Tag" } }
    it "should be valid with valid attributes" do
      expect(Tag.new(valid_attributes)).to be_valid
    end
    it "should be invalid without a name" do
      missing_name = valid_attributes.except(:name)
      expect(Tag.new(missing_name)).to_not be_valid
    end
  end
end
