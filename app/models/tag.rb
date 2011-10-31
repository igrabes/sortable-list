class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :jobs, :through => :taggings
  
  
  def display_name
    name.titleize.gsub("E ", "e")
  end
end
