class User < ActiveRecord::Base
  has_many :appointments
  belongs_to :domain
  has_many :tasks
  
end
