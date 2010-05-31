class Permission < ActiveRecord::Base
  # Permissions auf Rollen Basis oder User Basis
  #
  # permissible_type ist 'Domain' wenn Berechtigung fuer eine Rolle
  # und 'User' wenn spezielle Berechtigung fuer User
  #
  # permissible_id ist dann entsprechend die ID der Domain oder des Users
  #


  belongs_to :user
  
  belongs_to :domain
  
  belongs_to :permissible, :polymorphic => true
  
  validates_presence_of :permissible_id, :permissible_type, :action
  validates_format_of :action, :with => /^[a-z_]+$/
  validates_numericality_of :permissible_id
  validates_uniqueness_of :action, :scope => [:permissible_id,:permissible_type]
  
  def to_hash
    self.new_record? ? {} : {self.action => self.granted}
  end
  
end