class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications, id: false, primary_key: :app_token do |t|
      t.string :app_token, null: false
      t.string :name, null: false, index: true
      t.integer :chats_count, default: 0

      t.timestamps
    end
  end
end
