class TodosController < UITableViewController
  def viewDidLoad
    @items = []
    navigationItem.title = 'TODOs'
    view.backgroundColor = UIColor.whiteColor
    self.refreshControl = UIRefreshControl.new.tap do |r|
      r.addTarget(self, action:'load_todos', forControlEvents:UIControlEventValueChanged)
    end
    load_todos
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @items.count
  end

  CELL_ID = 'todo_cell'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    todo = @items[indexPath.row]
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CELL_ID)
    cell.textLabel.text = todo.title
    cell.detailTextLabel.text = todo.body
    cell.textLabel.textColor = todo.done ? UIColor.blueColor : UIColor.blackColor
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    todo = @items[indexPath.row]
    p todo
  end

  private
  def load_todos
    BW::HTTP.get('http://localhost:3000/todos.json') do |response|
      if response.ok?
        @items = []
        json = BW::JSON.parse(response.body.to_str)
        json.each do |hash|
          todo = Todo.new(hash)
          @items << todo
        end
        tableView.reloadData
      else
        App.alert('エラーが起きました')
      end
      self.refreshControl.endRefreshing
    end
  end
end