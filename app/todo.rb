class Todo
  attr_accessor :remote_id, :title, :body, :done

  def initialize(hash = {})
    @remote_id = hash['id']
    @title = hash['title']
    @body = hash['body']
    @done = hash['done']
  end
end