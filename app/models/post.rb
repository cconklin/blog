class Post < ActiveRecord::Base
  validates :title, :body, presence: true
  has_many :taggings
  has_many :tags, through: :taggings
  scope :with_tags, ->(tags) { all.joins(:taggings).where("taggings.tag_id" => tags) }
end
