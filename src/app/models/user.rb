class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_permissible

  has_many :appointments
  has_many :domains, :through => :domain_memberships
  has_many :tasks , :foreign_key => "creator_user_id"
  has_many :diagnoses

  validates_presence_of :password, :password_confirmation, :on => :create

  validates_presence_of :username, :email, :first_name, :family_name, :address,
                        :phone, :language, :message => 'should not be blank'
  
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/,
                      :message => 'is not a valid e-mail address', :if => :email?

  #validates_uniqueness_of :username, :scope => :id

  def self.check_for_admin
    adminuser = User.find_by_id(1)
    
    return adminuser == nil
  end

  def self.status
    check_for_admin
  end

  def self.message
    if check_for_admin
      I18n.t("admin.status.user.error")
    else
      I18n.t("admin.status.user.ok")
    end
  end

  def self.setup
    link = "/users/setup"

    link
  end

end
