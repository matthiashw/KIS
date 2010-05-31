class DomainMembership < ActiveRecord::Base
  # Domain <-> User Zuordnung
  #
  # roleable_type ist 'User' oder wenn 'Domain' wenn es eine Unterrolle ist
  #
  # roleable_id ist die UserID
  #
  # domain_id ist die DomainID
  # 

  belongs_to :user
  belongs_to :domain
  belongs_to :roleable, :polymorphic => true
  
  validates_presence_of :roleable_id, :roleable_type, :domain_id
  validates_uniqueness_of :domain_id, :scope => [:roleable_id, :roleable_type]
  validates_numericality_of :roleable_id, :domain_id
  validates_format_of :roleable_type, :with => /^[A-Z]{1}[a-z0-9]+([A-Z]{1}[a-z0-9]+)*$/
  validate :domain_does_not_belong_to_itself_in_a_loop
  
  protected
  def domain_does_not_belong_to_itself_in_a_loop
    if roleable_type == "Domain"
      if domain_id == roleable_id
        errors.add_to_base("A domain cannot belong to itself.")
      else
        if belongs_to_itself_through_other?(roleable_id, domain_id)
          errors.add_to_base("A domain cannot belong to a domain which belongs to it.")
        end
      end
    end
  end
  
  def belongs_to_itself_through_other?(original_roleable_id, current_domain_id)
    if self.class.find(:first, :select => "id", :conditions => ["roleable_id=? AND roleable_type='Domain' AND domain_id=?",current_domain_id,original_roleable_id])
      return true
    else
      memberships = self.class.find(:all, :select => "domain_id", :conditions => ["roleable_id=? AND roleable_type='Domain'",current_domain_id])
      if memberships.any? {|membership| belongs_to_itself_through_other?(original_roleable_id,membership.domain_id)}
        return true
      end
    end
    return false
  end
end