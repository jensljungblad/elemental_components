class Comment
  attr_reader :id, :user, :body

  def initialize(id: nil, user: nil, body: nil)
    @id = id
    @user = user
    @body = body
  end
end
