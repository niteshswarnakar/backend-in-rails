require "rails_helper"

RSpec.describe Content, type: :model do
  describe "validations" do
    it "is valid with a title, body, and user" do
      content = build(:content)
      expect(content).to be_valid
    end

    it "is invalid without a title" do
      content = build(:content, title: nil)
      expect(content).not_to be_valid
      expect(content.errors[:title]).to include("can't be blank")
    end

    it "is invalid without a body" do
      content = build(:content, body: nil)
      expect(content).not_to be_valid
      expect(content.errors[:body]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "belongs to a user" do
      content = build(:content)
      expect(content.user).to be_present
    end

    it "is invalid without a user" do
      content = build(:content, user: nil)
      expect(content).not_to be_valid
      expect(content.errors[:user]).to include("must exist")
    end
  end

  describe "#assign_uuid" do
    it "assigns a UUID when the id is blank" do
      content = build(:content, id: nil)
      content.valid?
      expect(content.id).to be_present
    end

    it "does not overwrite an id that is already set" do
      existing_id = SecureRandom.uuid
      content = build(:content, id: existing_id)
      content.valid?
      expect(content.id).to eq(existing_id)
    end
  end
end
