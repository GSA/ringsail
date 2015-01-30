# == Schema Information
#
# Table name: official_tags
#
#  id         :integer          not null, primary key
#  shortname  :string(255)
#  tag_text   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class OfficialTag < ActiveRecord::Base
  #handles logging of activity
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  #handles versioning
  has_paper_trail
  #attr_accessible :shortname, :tag_text
  
  validates :tag_text, :presence => true
  validates :shortname, :presence => true, :uniqueness => true
  
  before_validation :fix_shortname
  
  def self.autocomplete(input)
    if (input.nil? or input.length < 2)
      self.all
    else
      self.where(["LOWER(official_tags.tag_text) LIKE ?", "#{input.downcase}%"])    
    end
  end
  
  private
  
  def fix_shortname
    self.shortname = squish_tag(shortname) || squish_tag(tag_text)
    self.tag_text ||= shortname
  end

  def squish_tag(tag_text='')
    unless tag_text.nil? || tag_text.empty?
      tag_text.downcase.gsub(/\W/,'')
    end
  end
end
