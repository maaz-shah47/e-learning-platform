class Course < ApplicationRecord
  extend FriendlyId

  validates :title, presence: true, uniqueness: true
  validates :short_description, :language, :level, :price, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  friendly_id :title, use: :slugged
  def to_s
    title
  end

  LANGUAGES = [:"English", :"Urdu", :"Russian", :"Pico  "]
  LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]

  def self.languages
    LANGUAGES.map{ |language| [language, language] }
  end

  def self.levels
    LEVELS.map{ |level| [level, level] }
  end
  belongs_to :user
  has_rich_text :description
end
