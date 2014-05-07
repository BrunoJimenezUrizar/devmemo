class Attendee < ActiveRecord::Base
  attr_accessible :mobile_user_id, :event_id
  belongs_to :event
  belongs_to :mobile_user

	# Make sure that one user cannot join the same event more than once at a time.
	validates :event_id, :uniqueness => { :scope => :mobile_user_id }
end
