class Course < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :short_description, :language, :level, :price, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  extend FriendlyId
  friendly_id :title, use: :slugged

  LANGUAGES = [:English, :Urdu, :Russian, :"Pico  "]
  LEVELS = %i[Beginner Intermediate Advanced]

  scope :latest_courses, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular_courses, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }


  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  def progress(user)
    unless self.lessons_count == 0
      user_lessons.where(user: user).count/self.lessons_count.to_f*100
    end
  end

  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  belongs_to :user, counter_cache: true
  # User.find_each {|user| User.reset_counters(user.id, :courses)}

  has_many :lessons, dependent: :destroy
  has_many :enrollments
  has_many :user_lessons, through: :lessons

  has_rich_text :description

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, enrollments.average(:rating).round(2).to_f
    else
      update_column :average_rating, 0
    end
  end

  def to_s
    title
  end

  def bought(user)
    enrollments.where(user_id: [user.id], course_id: [id]).empty?
  end
end
