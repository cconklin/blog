class Comment < ActiveRecord::Base
  belongs_to :post
  validates :body, presence: true

  def reply?
    comment_id.present?
  end

end
