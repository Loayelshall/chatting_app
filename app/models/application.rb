class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  validates_presence_of :name
end
