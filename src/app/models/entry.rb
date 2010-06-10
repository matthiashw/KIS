class Entry < ActiveRecord::Base
  validates_presence_of :node,:code,:name,:type
  belongs_to :node 
end

