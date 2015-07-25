class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :comment
  has_many :replies, class_name: "Comment", foreign_key: "comment_id", dependent: :destroy
  validates :body, presence: true

  def reply?
    comment_id.present?
  end

end
