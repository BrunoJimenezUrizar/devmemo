class Comment < ActiveRecord::Base
  belongs_to :complaint
  belongs_to :user
  attr_accessible :body, :public, :user_id,:admin_name
  scope :ordered, order("created_at DESC")

  validates_presence_of :body

  def created_at_local
  	self.created_at.localtime
  end

  def admin_name
  	return User.find(self.user_id).name
  end
end
