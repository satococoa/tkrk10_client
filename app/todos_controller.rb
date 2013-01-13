class TodosController < UITableViewController
  API_BASE = 'http://localhost:3000'
  def viewDidLoad
    @items = []
    navigationItem.title = 'TODOs'
    view.backgroundColor = UIColor.whiteColor
    self.refreshControl = UIRefreshControl.new.tap do |r|
      r.addTarget(self, action:'load_todos', forControlEvents:UIControlEventValueChanged)
    end
    create_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'show_create_form')
    navigationItem.rightBarButtonItem = create_button
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
    show_todo_form(todo)
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
        data = {todo: form.render}
        update_todo(todo.remote_id, data)
      end
    end
  end

  def update_todo(remote_id, data)
    url = API_BASE + "/todos/#{remote_id}"
    BW::HTTP.put(url, {payload: data}) do |response|
      if response.ok?
        self.navigationController.popViewControllerAnimated(true)
        load_todos
      else
        App.alert('更新に失敗しました')
      end
    end
  end

  def show_create_form
    show_todo_form(Todo.new)
  end

  def show_todo_form(todo)
    form = setup_form(todo)
    controller = Formotion::FormController.alloc.initWithForm(form)
    navigationController.pushViewController(controller, animated:true)
  end
end