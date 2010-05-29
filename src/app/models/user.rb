class User < ActiveRecord::Base
  acts_as_authentic

  has_many :appointments
  belongs_to :domain
  has_many :tasks , :foreign_key => "creator_user_id"
  has_many :diagnoses


end
