class AddDifficultyToLessons < ActiveRecord::Migration[7.1]
  def change
    add_column :lessons, :difficulty, :string
  end
end
