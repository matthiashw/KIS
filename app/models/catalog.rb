class Catalog < ActiveRecord::Base
  
  validates_presence_of :year,:language,:root_node
  belongs_to :root_node , :class_name => "Node" , :foreign_key => "root_node_id" , :dependent => :destroy
  belongs_to :catalog_type
  has_many :medical_templates
  has_many :entries
  def catalog_select_name
       "#{catalog_type.name} [#{year}] (#{language})"
  end

  def search_for_entries pattern
    entryhashes=Array.new
    i=0
    pattern.split(' ').each do |patternpart|
      if patternpart !=""
        myentries=Entry.all :select => 'id',:conditions => ["catalog_id=? and (code LIKE ? or description LIKE ? or name LIKE ?)" , id ,"%#{patternpart}%","%#{patternpart}%","%#{patternpart}%"], :order => "name ASC"

        entryhashes[i]=Array.new
        myentries.each do |entry|
          entryhashes[i].push entry.id
        end
        i=i+1
      end

    end
    if entryhashes.empty?
      return nil
    end
      entry_ids=entryhashes[0]
      entryhashes.each { |entryhash|
          entry_ids = entryhash & entry_ids
      }
      entries=Entry.find :all, :conditions => { :id=>entry_ids }
      return entries

  end

end
