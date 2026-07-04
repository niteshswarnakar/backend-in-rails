class Api::V1::ContentsController < ApplicationController
  before_action :set_content, only: [ :show, :update, :destroy ]
  before_action :authorize_owner!, only: [ :show, :update, :destroy ]

  def index
    contents = Content.all
    render json: ContentSerializer.collection(contents), status: :ok
  end

  # It was not in task, but I kept it for testing purpose.
  def show
    render json: ContentSerializer.new(@content).as_json, status: :ok
  end

  # It was also not in task, but I kept it for testing purpose.
  def mine
    contents = current_user.contents
    render json: ContentSerializer.collection(contents), status: :ok
  end

  def create
    content = current_user.contents.build(content_params)
    if content.save
      render json: ContentSerializer.new(content).as_json, status: :created
    else
      render json: { errors: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @content.update(content_params)
      render json: ContentSerializer.new(@content).as_json, status: :ok
    else
      render json: { errors: @content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @content.destroy
    head :no_content
  end

  private
  def set_content
    @content = Content.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Content not found" }, status: :not_found
  end

  def authorize_owner!
    if @content.user_id != current_user.id
      render json: { error: "You are not authorized to access this content" }, status: :forbidden
    end
  end

  def content_params
    params.permit(:title, :body)
  end
end
