class User < ApplicationRecord
  has_secure_password

  has_many :contents, dependent: :destroy
  validates :first_name, :last_name, presence: true
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            format: {
              with: /\A(?=.*[A-Z])(?=.*\d)(?=.*[@#$%&]).{6,}\z/,
              message: "must be at least 6 characters and include an uppercase letter, a number, and a symbol (@#$%&)"
            },
            allow_nil: true

  before_validation :assign_uuid

  private

  def assign_uuid
    self.id ||= SecureRandom.uuid
  end
end
