class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_permissible

  has_many :appointments
  belongs_to :domain
  has_many :tasks , :foreign_key => "creator_user_id"
  has_many :diagnoses

  validates_presence_of :username, :email, :password, :password_confirmation,
                        :first_name, :family_name, :address,
                        :phone, :language, :message => 'should not be blank'
  
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/,
                      :message => 'is not a valid  e-mail address', :if => :email?

end
