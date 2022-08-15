class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true

  validates :user_id, uniqueness: { scope: :course_id }
  validates :course_id, uniqueness: { scope: :user_id }

  validate :cant_subscribe_to_own_course  #user can't create a subscription if course.user == current_user.id

  def to_s
    user.to_s + " " + course.to_s
  end

  protected

  def cant_subscribe_to_own_course
    if self.new_record?
      if self.user_id.present?
        if self.user_id == course.user_id
          errors.add(:base, "You can not subscribe to your own course")
        end
      end
    end
  end

end
