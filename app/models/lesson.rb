class Lesson < ApplicationRecord
  belongs_to :course
  
  validates :title, presence: true, uniqueness: true
  validates :content, presence: true, length: { minimum: 5 }
  validates :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged
end
