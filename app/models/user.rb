class User < ApplicationRecord
  belongs_to :photo, required: false
  validates :phone, presence: true, allow_nil: false
  validates :name, presence: true
end
