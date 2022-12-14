class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  has_many :courses
  has_many :enrollments
  has_many :user_lessons

  after_create :assign_default_role

  extend FriendlyId
  friendly_id :email, use: :slugged

  def username
    self.email.split(/@/)[0]
  end

  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end
  end

  def view_lesson(lesson)
    unless self.user_lessons.where(lesson: lesson).any?
      self.user_lessons.create(lesson: lesson)
    end
  end

  validate :must_have_a_role, on: :update

  def online?
    updated_at > 2.minutes.ago
  end

  def must_have_a_role
    if self.roles.blank?
      errors.add(:roles, "must have at least one role.")
    end
  end

  def to_s
    email
  end

  def buy_course(course)
    self.enrollments.create!(course: course, price: course.price)
  end
end
