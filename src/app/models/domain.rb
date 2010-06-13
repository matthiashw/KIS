class Domain < ActiveRecord::Base
  has_many :domain_memberships, :as => :roleable, :dependent => :destroy
  has_many :domains, :through => :domain_memberships, :source => :domain
  
  has_many :roleables, :class_name => "DomainMembership", :foreign_key => "domain_id", :dependent => :destroy
  has_many :subdomains, :through => :roleables, :source => :roleable, :source_type => 'Domain'
  has_many :users, :through => :roleables, :source => :roleable, :source_type => 'User'
  
  has_many :templates
  has_many :tasks

  validates_uniqueness_of :name
  validates_presence_of :name
  
  acts_as_permissible
end