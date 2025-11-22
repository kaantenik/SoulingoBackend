class CreateAnalyses < ActiveRecord::Migration[7.1]
  def change
    create_table :analyses do |t|
      t.references :recording, null: false, foreign_key: true
      t.float :fluency_score
      t.float :accuracy_score
      t.float :overall_score
      t.text :feedback

      t.timestamps
    end
  end
end
