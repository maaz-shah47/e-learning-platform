class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  # User.find_each {|user| User.reset_counters(user.id, :enrollments)}
  belongs_to :user, counter_cache: true

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  validates :user, :course, presence: true
  validates :rating, presence: true, on: :update
  validates :review, presence: true, on: :update
  validates :user_id, uniqueness: { scope: :course_id }
  validates :course_id, uniqueness: { scope: :user_id }

  validate :cant_subscribe_to_own_course  # user can't create a subscription if course.user == current_user.id

  scope :pending_review, -> { where(rating: [0, nil, ''], review: [0, nil, '']) }
  scope :reviewed, -> { where.not(review: [0, nil, ""]) }
  scope :latest_reviews, -> { limit(3).order(rating: :desc, created_at: :desc) }


  def to_s
    user.to_s + ' ' + course.to_s
  end

  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  after_destroy do
    course.update_rating
  end

  protected

  def cant_subscribe_to_own_course
    if new_record? && user_id.present? && (user_id == course.user_id)
      errors.add(:base, 'You can not subscribe to your own course')
    end
  end
end
