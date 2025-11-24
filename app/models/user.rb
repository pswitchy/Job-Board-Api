class User < ApplicationRecord
  has_secure_password

  # Note the colon :role and the comma
  enum :role, { seeker: 0, employer: 1, admin: 2 }

  has_one :profile, dependent: :destroy
  has_one :company, dependent: :destroy 
  has_many :applications, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end