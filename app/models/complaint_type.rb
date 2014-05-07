class ComplaintType < ActiveRecord::Base
  belongs_to :university
  has_many :complaints, :dependent => :destroy
  attr_accessible :name, :university

  before_destroy :reassign, :check_default_types
  before_update :check_default_types

  scope :ordered, order("id ASC")

  def reassign
  	self.complaints.each do |c|
  		c.complaint_type_id = c.campus.university.complaint_types.first.id
  	end
  end

  def check_default_types
  	if self.id == self.university.complaint_types.first.id
  		false
	end
  end

  def first?
  	if self.university.complaint_types.ordered.first.id == self.id
  		true
  	else
  		false
  	end
  end

end
