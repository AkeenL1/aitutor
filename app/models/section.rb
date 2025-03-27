class Section < ApplicationRecord
  has_many :lessons
  belongs_to :course
end
