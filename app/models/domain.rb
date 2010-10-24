class Domain < ActiveRecord::Base
  has_many :domain_memberships, :as => :roleable, :dependent => :destroy
  has_many :domains, :through => :domain_memberships, :source => :domain
  
  has_many :roleables, :class_name => "DomainMembership", :foreign_key => "domain_id", :dependent => :destroy
  has_many :subdomains, :through => :roleables, :source => :roleable, :source_type => 'Domain'
  has_many :users, :through => :roleables, :source => :roleable, :source_type => 'User'
  
  has_many :medical_templates
  has_many :tasks

  validates_uniqueness_of :name, :scope => :id
  validates_presence_of :name
  
  acts_as_permissible

  def self.userdomains
    Domain.find(:all,:conditions => [ "is_userdomain = ? AND id > ?", 1, 1 ])
  end
end