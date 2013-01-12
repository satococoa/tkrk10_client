class Todo
  attr_accessor :title, :body, :done
  def initialize(hash = {})
    @title = hash['title']
    @body = hash['body']
    @done = hash['done']
  end
end