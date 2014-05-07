class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :poi
  belongs_to :event
  # attr_accessible :title, :body
end
