class TodosController < UITableViewController
  API_BASE = 'http://localhost:3000'
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
    form = setup_form(todo)
    controller = Formotion::FormController.alloc.initWithForm(form)
    navigationController.pushViewController(controller, animated:true)
  end

  private
  def load_todos
    BW::HTTP.get(API_BASE + '/todos.json') do |response|
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

  def setup_form(todo)
    form = Formotion::Form.new.tap do |f|
      f.build_section do |section|
        section.build_row do |row|
          row.title = 'title'
          row.key = :title
          row.value = todo.title
          row.type = :string
        end
        section.build_row do |row|
          row.title = 'body'
          row.key = :body
          row.value = todo.body
          row.type = :string
        end
        section.build_row do |row|
          row.title = 'done'
          row.key = :done
          row.value = todo.done
          row.type = :switch
        end
      end
      f.build_section do |section|
        section.build_row do |row|
          row.title = 'Submit'
          row.type = :submit
        end
      end
      f.on_submit do |form|
        p form.render
      end
    end
  end
end