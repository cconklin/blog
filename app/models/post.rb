class Post < ActiveRecord::Base
  validates :title, :body, presence: true
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  scope :with_tags, ->(tags) { all.joins(:taggings).where("taggings.tag_id" => tags) }

  def tag_names
    tags.pluck(:name)
  end
  def tag_names=(names)
    self.tags = names.reject(&:empty?).map do |name|
      Tag.find_or_create_by(name: name)
    end
  end

end
