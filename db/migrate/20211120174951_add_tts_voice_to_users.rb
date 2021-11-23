class AddTtsVoiceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tts_voice, :string
  end
end
