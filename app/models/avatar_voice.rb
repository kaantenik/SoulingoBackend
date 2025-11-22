class AvatarVoice < ApplicationRecord
  validates :voice_id, presence: true
  validates :language, presence: true
end
