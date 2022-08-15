class Course < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :short_description, :language, :level, :price, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  extend FriendlyId
  friendly_id :title, use: :slugged

  LANGUAGES = [:"English", :"Urdu", :"Russian", :"Pico  "]
  LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]

  def self.languages
    LANGUAGES.map{ |language| [language, language] }
  end

  def self.levels
    LEVELS.map{ |level| [level, level] }
  end

  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_many :enrollments

  has_rich_text :description

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  def to_s
    title
  end

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
  end
end
