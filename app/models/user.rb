class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  def to_us
    email
  end

  has_many :courses

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

  validate :must_have_a_role, on: :update

  def must_have_a_role
    if self.roles.blank?
      errors.add(:roles, "must have at least one role.")
    end
  end
end
