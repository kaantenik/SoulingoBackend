class CreateAvatarVoices < ActiveRecord::Migration[7.1]
  def change
    create_table :avatar_voices do |t|
      t.string :provider, default: "thefluent"
      t.string :voice_id, null: false
      t.string :language, null: false

      t.timestamps
    end
  end
end
