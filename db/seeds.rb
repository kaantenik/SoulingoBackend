# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample lessons
lessons = [
  {
    title: "Basic Greetings",
    content: "Hello, how are you today?",
    language: "en-US"
  },
  {
    title: "Numbers 1-10",
    content: "One, two, three, four, five, six, seven, eight, nine, ten",
    language: "en-US"
  },
  {
    title: "Days of the Week",
    content: "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday",
    language: "en-US"
  }
]

lessons.each do |lesson_attrs|
  Lesson.find_or_create_by!(title: lesson_attrs[:title]) do |lesson|
    lesson.content = lesson_attrs[:content]
    lesson.language = lesson_attrs[:language]
  end
end

# Create sample avatar voices
voices = [
  {
    provider: "thefluent",
    voice_id: "emma",
    language: "en-US"
  },
  {
    provider: "thefluent",
    voice_id: "james",
    language: "en-US"
  },
  {
    provider: "thefluent",
    voice_id: "sophia",
    language: "en-GB"
  }
]

voices.each do |voice_attrs|
  AvatarVoice.find_or_create_by!(voice_id: voice_attrs[:voice_id]) do |voice|
    voice.provider = voice_attrs[:provider]
    voice.language = voice_attrs[:language]
  end
end

puts "Seed data created successfully!"
puts "- #{Lesson.count} lessons"
puts "- #{AvatarVoice.count} avatar voices"
