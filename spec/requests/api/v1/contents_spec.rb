require "rails_helper"

RSpec.describe "Api::V1::Contents", type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let(:content)    { create(:content, user: user) }

  def json
    JSON.parse(response.body)
  end

  describe "GET /api/v1/contents" do
    it "returns all contents for an authenticated user" do
      create_list(:content, 2, user: user)

      get "/api/v1/contents", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["data"].size).to eq(2)
    end

    it "returns 401 without a token" do
      get "/api/v1/contents"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/contents/mine" do
    it "returns only the current user's contents" do
      create_list(:content, 2, user: user)
      create(:content, user: other_user)

      get "/api/v1/contents/mine", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["data"].size).to eq(2)
    end
  end

  describe "GET /api/v1/contents/:id" do
    it "returns the content when the user owns it" do
      get "/api/v1/contents/#{content.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["data"]["id"]).to eq(content.id)
      expect(json["data"]["attributes"]["title"]).to eq(content.title)
    end

    it "returns 403 when the user does not own it" do
      get "/api/v1/contents/#{content.id}", headers: auth_headers(other_user)
      expect(response).to have_http_status(:forbidden)
    end

    it "returns 404 for a non-existent id" do
      get "/api/v1/contents/#{SecureRandom.uuid}", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end

    it "returns 401 without a token" do
      get "/api/v1/contents/#{content.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /api/v1/contents" do
    it "creates a content owned by the current user" do
      params = { title: "New Title", body: "New Body" }

      expect {
        post "/api/v1/contents", params: params, headers: auth_headers(user)
      }.to change(Content, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json["data"]["attributes"]["title"]).to eq("New Title")
      expect(Content.last.user_id).to eq(user.id)
    end

    it "returns 422 with invalid params" do
      params = { title: "", body: "" }

      post "/api/v1/contents", params: params, headers: auth_headers(user)

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to be_present
    end

    it "returns 401 without a token" do
      post "/api/v1/contents", params: { title: "x", body: "y" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /api/v1/contents/:id" do
    it "updates the content when the user owns it" do
      patch "/api/v1/contents/#{content.id}",
            params: { title: "Updated" }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["data"]["attributes"]["title"]).to eq("Updated")
      expect(content.reload.title).to eq("Updated")
    end

    it "returns 422 with invalid params" do
      patch "/api/v1/contents/#{content.id}",
            params: { title: "" }, headers: auth_headers(user)

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns 403 when the user does not own it" do
      patch "/api/v1/contents/#{content.id}",
            params: { title: "Hacked" }, headers: auth_headers(other_user)

      expect(response).to have_http_status(:forbidden)
      expect(content.reload.title).not_to eq("Hacked")
    end

    it "returns 404 for a non-existent id" do
      patch "/api/v1/contents/#{SecureRandom.uuid}",
            params: { title: "x" }, headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end

    it "returns 401 without a token" do
      patch "/api/v1/contents/#{content.id}", params: { title: "x" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/contents/:id" do
    it "deletes the content when the user owns it" do
      content_to_delete = create(:content, user: user)

      expect {
        delete "/api/v1/contents/#{content_to_delete.id}", headers: auth_headers(user)
      }.to change(Content, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 403 when the user does not own it" do
      delete "/api/v1/contents/#{content.id}", headers: auth_headers(other_user)

      expect(response).to have_http_status(:forbidden)
      expect(Content.exists?(content.id)).to be(true)
    end

    it "returns 404 for a non-existent id" do
      delete "/api/v1/contents/#{SecureRandom.uuid}", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end

    it "returns 401 without a token" do
      delete "/api/v1/contents/#{content.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
