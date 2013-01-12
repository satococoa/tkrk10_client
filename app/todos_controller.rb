class TodosController < UITableViewController
  def viewDidLoad
    @items = ['foo', 'bar', 'baz']
    navigationItem.title = 'TODOs'
    view.backgroundColor = UIColor.whiteColor
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @items.count
  end

  CELL_ID = 'todo_cell'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    todo = @items[indexPath.row]
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID)
    cell.textLabel.text = todo
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    todo = @items[indexPath.row]
    p todo
  end
end