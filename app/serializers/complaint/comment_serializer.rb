class Complaint::CommentSerializer < ActiveModel::Serializer
  attributes :id, :public, :body
  has_one :user
end
