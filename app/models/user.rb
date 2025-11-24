class User < ApplicationRecord
  has_secure_password

  # Roles: 0 = Job Seeker, 1 = Employer, 2 = Admin
  enum role: { seeker: 0, employer: 1, admin: 2 }

  has_one :profile, dependent: :destroy
  has_one :company, dependent: :destroy # For employers
  has_many :applications, dependent: :destroy # For seekers
  
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end