class User < ApplicationRecord
  has_secure_password

  before_validation :assign_uuid

  private

  def assign_uuid
    self.id ||= SecureRandom.uuid
  end
end
