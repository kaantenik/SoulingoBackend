class Lesson < ApplicationRecord
  has_many :recordings, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
  validates :language, presence: true
  validates :difficulty, presence: true, inclusion: { in: %w[beginner intermediate advanced] }
end
