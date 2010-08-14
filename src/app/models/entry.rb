class Entry < ActiveRecord::Base
  validates_presence_of :node,:code,:name,:type,:catalog
  belongs_to :node
  belongs_to :catalog
end

