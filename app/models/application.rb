class Application < ApplicationRecord
  validates_presence_of :name
  has_secure_token
end
