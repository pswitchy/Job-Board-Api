class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :resume # ActiveStorage

  validates :full_name, presence: true
end