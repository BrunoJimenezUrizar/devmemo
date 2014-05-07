class Dump < ActiveRecord::Base
  attr_accessible :description, :por_id, :qr_code, :type_id, :visits,:type, :type_s
  belongs_to :type
  belongs_to :por
  
  validates_presence_of :type_id

  #atributos virtual
  def type_s
  	return self.type.name
  end
end
