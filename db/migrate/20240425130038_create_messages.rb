class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.integer :number, null: false
      t.string :message, null: false
      t.references :chat, foreign_key: true

      t.timestamps
    end
  end
end
