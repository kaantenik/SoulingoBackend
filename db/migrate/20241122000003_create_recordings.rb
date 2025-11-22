class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :recordings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.string :audio_url, null: false
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
