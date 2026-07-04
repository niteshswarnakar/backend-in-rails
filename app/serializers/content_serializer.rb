class ContentSerializer
  def initialize(content)
    @content = content
  end


  def serializable_hash
    {
        id: @content.id,
        type: "contents",
        attributes: {
          title: @content.title,
          body: @content.body,
          createdAt: @content.created_at,
          updatedAt: @content.updated_at
      }
    }
  end

  def as_json(*)
    { data: serializable_hash }
  end

  def self.collection(contents)
    { data: contents.map { |content| new(content).serializable_hash } }
  end
end
