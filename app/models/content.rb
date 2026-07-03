class Content < ApplicationRecord
  belongs_to :user

  validates :title, :body, presence: true

  before_validation :assign_uuid

  private

  def assign_uuid
    self.id ||= SecureRandom.uuid
  end
end
