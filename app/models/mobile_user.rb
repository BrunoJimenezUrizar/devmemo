class MobileUser < ActiveRecord::Base
  attr_accessible :api_token, :email, :name,:last_name,:profile_picture_url, :fb_id, :access_token, :complaints, :score, :level
  validates_uniqueness_of :email, :api_token
  before_create :generate_api_token
  has_many :complaints
  has_many :events
  has_many :attendees, :dependent => :destroy
  has_many :events, :through => :attendees
  has_many :answer_groups, :class_name => "Rapidfire::AnswerGroup"
  
  def recycles (from, to)
    recycle= Hash.new
    total= RecycleInfo.where({mobile_user_id:self.id, created_at:from..to}).count
    Type.all.each do|type|
      if total !=0
      recycle[type]=RecycleInfo.where({mobile_user_id:self.id, type_id:type.id,created_at:from..to}).count*100/total
      else
      recycle[type]=0
      end  
    end
    recycle["all"]=total
    return recycle
  end

  def at_events(university_id, from, to)
    campus_ids= Campus.where(university_id:university_id).pluck(:id)
    event_ids= Event.where(campus_id:campus_ids).pluck(:id)
    return Attendee.where({mobile_user_id:self.id, created_at:from..to, event_id:event_ids}).count
  end

  def level
    levels = Level.order("points DESC").all
    levels.each do |level|
      if self.score >= level.points
        return level.name
      end
    end
    return levels.last.name
  end

  def full_name
    return self.name+" "+self.last_name
  end

  private 
  def generate_api_token
    begin
      self.api_token = SecureRandom.hex
    end while self.class.exists?(api_token: api_token)
  end
  
end
