class Post < ActiveRecord::Base
  validates :title, :body, presence: true
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :comments, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  scope :with_tags, ->(tags) { all.joins(:taggings).where("taggings.tag_id" => tags) }

  def tag_names
    # #pluck does not work when previewing
    tags.map(&:name)
  end
  def tag_names=(names)
    self.tags = names.reject(&:empty?).map do |name|
      Tag.find_or_create_by(name: name)
    end
  end

end
