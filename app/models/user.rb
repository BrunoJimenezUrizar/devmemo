class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids
  attr_accessible :campus_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :campuses
  # attr_accessible :title, :body

  has_many :usercampuses
  has_many :campuses, through: :usercampuses

  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
end
