class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  validates :user, :course, presence: true
  validates :rating, presence: true, on: :update
  validates :review, presence: true, on: :update
  validates :user_id, uniqueness: { scope: :course_id }
  validates :course_id, uniqueness: { scope: :user_id }

  validate :cant_subscribe_to_own_course  # user can't create a subscription if course.user == current_user.id

  scope :pending_review, -> { where(rating: [0, nil, ''], review: [0, nil, '']) }
  def to_s
    user.to_s + ' ' + course.to_s
  end

  protected

  def cant_subscribe_to_own_course
    if new_record? && user_id.present? && (user_id == course.user_id)
      errors.add(:base, 'You can not subscribe to your own course')
    end
  end
end
