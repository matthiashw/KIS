class Domain < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :permissions
  has_many :templates
  has_many :tasks
  
end
