class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(App.bounds)
    todos_controller = TodosController.new
    navigation = UINavigationController.alloc.initWithRootViewController(todos_controller)
    @window.rootViewController = navigation
    @window.makeKeyAndVisible
    true
  end
end
