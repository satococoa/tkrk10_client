class TodosController < UITableViewController
  def viewDidLoad
    @items = [
      Todo.new({'title' => 'foo', 'body' => 'foo body', 'done' => true}),
      Todo.new({'title' => 'bar', 'body' => 'bar body', 'done' => false}),
      Todo.new({'title' => 'baz', 'body' => 'baz body', 'done' => true})
    ]
    navigationItem.title = 'TODOs'
    view.backgroundColor = UIColor.whiteColor
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
end