class Section < ApplicationRecord
  has_many :lessons, dependent: :destroy
  belongs_to :course
end
