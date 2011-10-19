class Question < ActiveRecord::Base
  belongs_to :book
  has_many :answers
  
  accepts_nested_attributes_for :answers
end
