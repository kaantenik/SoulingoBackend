class Recording < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  has_one :analysis, dependent: :destroy

  validates :audio_url, presence: true
end
