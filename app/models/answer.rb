class Answer < ActiveRecord::Base  
  
  acts_as_voteable
  
  belongs_to :question
  belongs_to :job
  belongs_to :user
 
  
end
