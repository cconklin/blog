class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  validates :body, presence: true

  def reply?
    comment_id.present?
  end

end
