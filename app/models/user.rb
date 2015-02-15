class User < ActiveRecord::Base
  has_secure_password

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 35 },
            format: { with: /\A[a-zA-Z0-9]+\Z/ }
end
